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
router.post("/signup", upload.single("image"), userCtr.signUp);
router.post("/adduser", upload.single("image"), authMiddleware, checkAdminMiddleware, userCtr.AddUser);
router.get(
    "/signup/requests",
    authMiddleware,
    checkAdminMiddleware,
    userCtr.getSignUpRequests
);
router.post("/login", userCtr.login)
router.post("/confirm-signup/:id", userCtr.confirmSignUp);
router.patch(
    "/update/:id",
    upload.single("image"),
    authMiddleware,
    userCtr.UpdateUser
);
router.patch(
    "/update-roles/:id",
    authMiddleware,
    checkAdminMiddleware,
    userCtr.updateUserRoles
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
module.exports = router;