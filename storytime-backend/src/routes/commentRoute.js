const express = require("express");
const router = express.Router();
const commentCtrl = require("../controllers/commentController");
const { fileStorageEngine } = require('../tools/FileStorageEngine')

const { authMiddleware } = require("../middlewares/authMiddleware");
const multer = require("multer");
const { checkAdminMiddleware } = require("../middlewares/checkAdminMiddleware");
const upload = multer({ storage: fileStorageEngine });



// router.get('/getCommentsByUser/:id',storyCtrl.getStoriesByUser);
router.get('/getCommentsForStory/:id',commentCtrl.getCommentsForStory);
// router.get('/getCommentById/:id', authMiddleware, procesvCtrl.getProcesById)
router.post('/addComment/:id', commentCtrl.addComment);
//router.patch('/updateComment/:id',authMiddleware, storyCtrl.shareStory);
//router.put('/updateStory/:id', authMiddleware, procesvCtrl.updateProcesv);
//router.delete('/deleteComment/:id',  authMiddleware, checkAdminMiddleware, storyCtrl.deleteStory)

module.exports = router;