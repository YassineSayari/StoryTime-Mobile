const express = require("express");
const router = express.Router();
const storyCtrl = require("../controllers/storyController");
const { fileStorageEngine } = require('../tools/FileStorageEngine')

const { authMiddleware } = require("../middlewares/authMiddleware");
const multer = require("multer");
const { checkAdminMiddleware } = require("../middlewares/checkAdminMiddleware");
const upload = multer({ storage: fileStorageEngine });



router.get('/getAllStories', authMiddleware, storyCtrl.getAllStories);
router.get('/getStoriesByUser/:id',storyCtrl.getStoriesByUser);
router.get('/getSharedStories/',storyCtrl.getSharedStories);
//router.get('/getStoryById/:id', authMiddleware, procesvCtrl.getProcesById)
router.post('/addStory', storyCtrl.createStory);
router.patch('/shareStory/:id',authMiddleware, storyCtrl.shareStory);
//router.put('/updateStory/:id', authMiddleware, procesvCtrl.updateProcesv);
router.delete('/deleteStory/:id',  authMiddleware, checkAdminMiddleware, storyCtrl.deleteStory)

module.exports = router;