const { ObjectId } = require("mongodb");
const User = require("../models/user");
const Roles = require("../models/roles");
const bcrypt = require("bcryptjs");
const crypto = require("crypto");
const jwt = require("jsonwebtoken");
//const ForgetPassword = require("../models/forgotPassword");

require("dotenv/config");

const nodemailer = require("nodemailer");
//const moment = require("moment");
const user = require("../models/user");
//const reclamations = require("../models/reclamations");


module.exports.AddUser = async function(req, res, next) {
    const body = {...req.body };

    if (req.file && req.file.filename) {
        body.image = req.file.filename;
        console.log("Image provided...");
    } else {
        console.log("No image provided...");
    }

    try {
        console.log("hashing password...");
        hashedPassword = await bcrypt.hash(body.password, 10);
        body.password = hashedPassword;

        const user = await User.create({...body });

        const _user = await User.findByIdAndUpdate(user._id);
        if (_user) {
            res.status(200).json({
                message: "User added successfully",
                user: _user,
            });
        }
    } catch (error) {
        res.status(500).json({ error: "Error adding user", message: error.message });
    }
};


module.exports.signUp = async function(req, res, next) {

    const body = {...req.body };


    if (req.file && req.file.filename) {
        body.image = req.file.filename;
        console.log("Image provided...");
    } else {
        console.log("No image provided...");
    }
    console.log("Hashing password...");
    try {
        hashedPassword = await bcrypt.hash(body.password, 10);
        body.password = hashedPassword;
        console.log("Creating user...");
        const user = await User.create({...body });
        console.log("User created:", user);
        const _user = await User.findByIdAndUpdate(user._id);
        if (_user) {
            console.log("User updated:", _user);
            res.status(200).json({
                message: "Signup request sent successfully, waiting for admin confirmation",
                user: _user,
            });
        } else {
            console.log("User not found for updating");
            res.status(500).json({ error: "User not found for updating" });
        }
    } catch (error) {
        console.error("Error creating/updating user:", error);
        res.status(500).json({ error: "Error creating/updating user" });
    }
};


module.exports.login = async function(req, res, next) {
    try {
        let fetchedUser = await User.findOne({ email: req.body.email }).populate(
            "roles"
        );
        if (!fetchedUser) {
            return res.status(404).json({ message: "Wrong Email or Password" });
        }

        if (!fetchedUser.isEnabled) {
            return res.status(500).json({
                message: "Unauthorised login. Waiting for register confirmation ",
            });
        }
        var result = await bcrypt.compare(req.body.password, fetchedUser.password);
        if (!result) {
            return res.status(500).json({ message: "Wrong email or password" });
        }
        const token = jwt.sign({
                email: fetchedUser.email,
                id: fetchedUser._id,
            },
            "secret_this_should_be_longer", { expiresIn: "24h" }
        );
        return res.status(200).json({
            token: token,
            expiresIn: "24h",
            fullName: fetchedUser.fullName,
            image: fetchedUser.image,
            id: fetchedUser._id,
            roles: fetchedUser.roles,
        });
    } catch (error) {
        return res.status(500).json({ message: "problem in bycript" });
    }
};
module.exports.checkPassword = async function(req, res, next) {
    try {
        let fetchedUser = await User.findById(req.body.id);

        var result = await bcrypt.compare(req.body.password, fetchedUser.password);
        if (!result) {
            return res.status(500).json("wrong password");
        }

        return res.status(200).json("ok");
    } catch (error) {
        return res.status(500).json({ message: "problem in bycript" });
    }
};

module.exports.updateUserRoles = async function(req, res) {
    const ID = req.params.id;
    if (!ObjectId.isValid(ID)) {
        return res.status(404).json("ID is not valid");
    }
    const body = {...req.body };
    console.log(body);
    var userRoles = [];

    body.roles.forEach((role) => {
        if (role == "Engineer") {
            userRoles.push(Roles.Engineer);
        }
        if (role == "Client") {
            userRoles.push(Roles.Client);
        }
        if (role == "Team Leader") {
            userRoles.push(Roles.TeamLeader);
        }
    });
    console.log(userRoles);
    User.findByIdAndUpdate(ID, { $set: { roles: userRoles } })
        .then(() => {
            res.status(200).json("roles updates");
        })
        .catch((error) => res.status(500).json(error));
};

module.exports.UpdateUser = async function(req, res, next) {
    const body = {...req.body };

    if (req.file) {
        body.image = req.file.filename;
    }
    const ID = req.params.id;
    if (!ObjectId.isValid(ID)) {
        return res.status(404).json("ID is not valid");
    }

    if (body.password) {
        try {
            body.password = await bcrypt.hash(body.password, 10);
        } catch (error) {
            return res.status(500).json(error);
        }
    }


    User.findByIdAndUpdate(ID, { $set: body })
        .then((result) => {
            User.findById(ID)
                .then((user) => {
                    return res.status(200).json(user);

                });
        })
        .catch((err) => {
            return res.status(500).json(err);
        });
};

module.exports.forgotPassword = async function(req, res, next) {
    try {
        const user = await User.findOne({ email: req.body.email });
        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }
        const code = Math.floor(Math.random() * 111111);
        await ForgetPassword.findOneAndDelete({ email: user.email });
        let forgetPassword = new ForgetPassword({
            email: req.body.email,
            code: code,
        });

        //send mail to user
        const transporter = nodemailer.createTransport({
            service: "gmail",
            port: 587,
            auth: {
                user: process.env.EMAIL,
                pass: process.env.PASSWORD,
            },
        });
        transporter.sendMail({
            from: process.env.EMAIL,
            to: user.email,
            subject: "Prologic -- Verification code for changing password",
            text: "This is your verification code for changing password : " + code,
        });

        forgetPassword.save();
        return res.status(200).json(forgetPassword);
    } catch (error) {
        return res.status(500).json({ error: error });
    }
};

module.exports.validateCode = async function(req, res) {
    try {
        let emailf = req.body.email;
        let forgetPassword = await ForgetPassword.findOne({
            email: emailf
        });

        if (forgetPassword.code === req.body.code) {
            return res.status(200).json({ ide: forgetPassword._id });
        } else {
            return res.status(500).json({ message: "Unauthorized" });
        }
    } catch (error) {
        return res.status(500).json(error);
    }
};

module.exports.changePswdAutorisation = async function(req, res) {
    const ID = req.params.id;

    if (!ObjectId.isValid(ID)) {
        return res.status(404).json("ID is not valid");
    }
    try {
        const forgotPassword = await ForgetPassword.findById(ID);
        if (forgotPassword) {
            res.status(200).json("ok");
        } else {
            res.status(401).json("error");
        }
    } catch (error) {
        res.status(401).json(error);
    }
};

module.exports.changePswd = async function(req, res) {
    const ID = req.params.id;

    if (!ObjectId.isValid(ID)) {
        return res.status(404).json("ID is not valid");
    }
    const body = {...req.body };

    try {
        body.password = await bcrypt.hash(body.password, 10);
        await User.findOneAndUpdate({ email: body.email }, { $set: body });
        await ForgetPassword.findByIdAndDelete(ID);
        res.status(200).json("password updated");
    } catch (error) {
        return res.status(500).json(error);
    }
};

module.exports.confirmSignUp = async function(req, res) {
    const ID = req.params.id;

    if (!ObjectId.isValid(ID)) {
        return res.status(404).json("ID is not valid");
    }

    const user = await User.findByIdAndUpdate(ID, { isEnabled: true });
    if (user) {
        const transporter = nodemailer.createTransport({
            service: "gmail",
            port: 587,
            auth: {
                user: process.env.EMAIL,
                pass: process.env.PASSWORD,
            },
        });
        // transporter.sendMail({
        //     from: process.env.EMAIL,
        //     to: user.email,
        //     subject: "Prologic -- register request accepted",
        //     text: "Your register request is accepted",
        // });
    }

    return res.status(200).json({ message: "User accepted" });
};

module.exports.getAllUsers = async function(req, res) {
    User.find({
            $and: [{ isEnabled: true }, { roles: { $ne: "Admin" } }],
        })
        .select("-password")

    .then((users) => {
            res.status(200).json(users);
        })
        .catch((error) => res.status(404).json({ message: error }));
};

module.exports.getSignUpRequests = async function(req, res) {
    User.find({ isEnabled: false })
        .select("-password")
        .then((users) => {
            res.status(200).json(users);
        })
        .catch((error) => res.status(404).json({ message: error }));
};

module.exports.deleteUser = async function(req, res) {
    const ID = req.params.id;

    if (!ObjectId.isValid(ID)) {
        return res.status(404).json("ID is not valid");
    }
    try {
        const user = await User.findByIdAndRemove({ _id: ID });
    } catch (error) {
        res.status(500).json({ message: error });
    }
};

module.exports.getUserById = async function(req, res) {
    const ID = req.params.id;

    if (!ObjectId.isValid(ID)) {
        return res.status(404).json("ID is not valid");
    }
    try {
        const user = await User.findById(ID);
        res.status(200).json(user);
    } catch (error) {
        res.status(500).json({ message: error });
    }
};

module.exports.filterUsers = async function(req, res) {
    var fullNameFilter = req.body.fullName;
    var titleFilter = req.body.title;
    var driversFilter = req.body.drivingLicense;
    var departmentFilter = req.body.department;
    if (fullNameFilter) {
        fullNameFilter = fullNameFilter.trim().length === 0 ? null : fullNameFilter;
    }
    if (titleFilter) {
        titleFilter = titleFilter.trim().length === 0 ? null : titleFilter;
    }
    if (driversFilter) {
        driversFilter = driversFilter.trim().length === 0 ? null : driversFilter;
    }
    if (departmentFilter) {
        departmentFilter =
            departmentFilter.trim().length === 0 ? null : departmentFilter;
    }

    try {
        if (driversFilter) {
            const users = await User.find({
                roles: { $ne: "Admin" },
                drivingLicense: true,
                isEnabled: true,
            });

            if (users) {
                res.status(200).json(users);
            }
        } else {
            const users = await User.find({
                $and: [
                    { roles: { $ne: "Admin" } },
                    { _id: { $ne: res.locals.user._id } },
                    { isEnabled: true },
                    {
                        $or: [{
                                fullName: fullNameFilter ?
                                    new RegExp(fullNameFilter, "i") : new RegExp("[a-zA-Z]"),
                            },
                            {
                                title: titleFilter ?
                                    new RegExp(titleFilter, "i") : new RegExp("[a-zA-Z]"),
                            },
                            {
                                department: departmentFilter ?
                                    new RegExp(departmentFilter, "i") : new RegExp("[a-zA-Z]"),
                            },
                        ],
                    },
                ],
            });

            if (users) {
                res.status(200).json(users);
            }
        }
    } catch (error) {
        res.status(500).json(error);
    }
};
module.exports.getusername = async function(req, res) {
    const ID = req.params.id;
    if (!ObjectId.isValid(ID)) {
        return res.status(404).json("ID is not valid");
    }
    try {
        const user = await User.findById(ID);
        res.status(200).json(user.fullName);
    } catch (error) {
        res.status(500).json({ message: error });
    }
}

module.exports.searchUsers = async function(req, res) {
    var fullNameFilter = req.body.fullName;
    var addressFilter = req.body.address;
    var titleFilter = req.body.title;
    var departmentFilter = req.body.department;
    var isNotEnabledFilter = req.body.isEnabled;
    if (fullNameFilter) {
        fullNameFilter = fullNameFilter.trim().length === 0 ? null : fullNameFilter;
    }
    if (titleFilter) {
        titleFilter = titleFilter.trim().length === 0 ? null : titleFilter;
    }

    if (departmentFilter) {
        departmentFilter =
            departmentFilter.trim().length === 0 ? null : departmentFilter;
    }
    if (addressFilter) {
        addressFilter = addressFilter.trim().length === 0 ? null : addressFilter;
    }
    if (isNotEnabledFilter) {
        isNotEnabledFilter =
            isNotEnabledFilter.trim().length === 0 ? null : isNotEnabledFilter;
    }

    try {
        const users = await User.find({
            roles: { $ne: "Admin" },
            isEnabled: isNotEnabledFilter ? false : true,
            _id: { $ne: res.locals.user._id },
            fullName: fullNameFilter ?
                new RegExp(fullNameFilter, "i") : new RegExp("[a-zA-Z]"),

            title: titleFilter ?
                new RegExp(titleFilter, "i") : new RegExp("[a-zA-Z]"),
            address: addressFilter ?
                new RegExp(addressFilter, "i") : new RegExp("[a-zA-Z]"),

            department: departmentFilter ?
                new RegExp(departmentFilter, "i") : new RegExp("[a-zA-Z]"),
        });

        if (users) {
            res.status(200).json(users);
        }
    } catch (error) {
        res.status(500).json(error);
    }
};