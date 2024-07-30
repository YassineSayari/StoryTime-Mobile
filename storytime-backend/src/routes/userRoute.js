const express = require("express");
const router = express.Router();
const userCtr = require("../controllers/userController");
const emailCtrl = require("../controllers/emailSender")
const { authMiddleware } = require("../middlewares/authMiddleware");
const { checkAdminMiddleware } = require("../middlewares/checkAdminMiddleware");
const { fileStorageEngine } = require("../tools/FileStorageEngine");
const multer = require("multer");
const { urlencoded } = require("body-parser");
const upload = multer({ storage: fileStorageEngine });

const passport = require("passport");
require("../config/passport-setup");




router.post("/signup", upload.single("image"), userCtr.signUp);
router.post("/adduser", upload.single("image"), authMiddleware, checkAdminMiddleware, userCtr.AddUser);
router.get(
    "/signup/requests",
    authMiddleware,
    checkAdminMiddleware,
    userCtr.getSignUpRequests
);
router.post("/login", userCtr.login)
router.post("/checkGoogleAuth",userCtr.checkGoogleAuth);
router.post("/confirm-signup/:id", userCtr.confirmSignUp);
router.patch(
    "/update/:id",
    upload.single("image"),
    authMiddleware,
    userCtr.UpdateUser
);

router.post("/forgotPassword", userCtr.forgotPassword);
router.post("/checkpass", userCtr.checkPassword);
router.post("/addUser", userCtr.AddUser);
router.post("/validateCode", userCtr.validateCode);
router.get("/changePswdAutorisation/:id", userCtr.changePswdAutorisation);
router.patch("/change-psw/:id", userCtr.changePswd);

router.get("/getall", userCtr.getAllUsers);
router.post("/filter", userCtr.filterUsers);
router.post("/search", authMiddleware, userCtr.searchUsers);

router.delete("/delete/:id", userCtr.deleteUser);

router.get("/getUserById/:id", userCtr.getUserById);
router.get("/getusername/:id", userCtr.getusername)

router.post("/email", emailCtrl.SendMail)

//GOOGLE AUTH
router.get(
    '/auth/google',
    passport.authenticate('google', { scope: ['profile', 'email'] })
  );



  router.get(
    '/auth/google/callback',
    passport.authenticate('google', { failureRedirect: '/login' }),
    (req, res) => {
      // Successful authentication, redirect or respond as needed
      const token = jwt.sign(
        {
          email: req.user.email,
          id: req.user._id,
        },
        'secret_this_should_be_longer',
        { expiresIn: '24h' }
      );
  
      res.status(200).json({
        token: token,
        expiresIn: '24h',
        fullName: req.user.fullName,
        image: req.user.image,
        id: req.user._id,
        roles: req.user.roles, // Ensure roles are set in the user schema
      });
    }
  );



module.exports = router;