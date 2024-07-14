const { ObjectId } = require("mongodb");
const Story = require('../models/story');
const User = require('../models/user');
const Comment = require('../models/comment');




module.exports.addComment = async function (req, res) {
    try {

        const storyId=req.params.id;
        // Extract data from request body
        const { comment, date, userId } = req.body;

        const existingUser = await User.findById(userId);
        if (!existingUser) {
            return res.status(404).json({
                message: 'userId not found',
                error: 'The specified userId does not exist'
            });
        }

        const newComment = new Comment({
            Comment: comment,
            Story: storyId,
            User: userId,
        });

        await newComment.save();

        await Story.findByIdAndUpdate(
            storyId,
            { $push: { Comments: newComment._id } },
            { new: true, useFindAndModify: false }
        );


        res.status(201).json({
            message: 'newComment created successfully',
            story: newComment
        });

    } catch (error) {
        // Handle errors
        res.status(500).json({
            message: 'Error creating newComment',
            error: error.message
        });
    }
};


module.exports.getCommentsForStory= async function(req,res){

    const id=req.params.id;

    const story = await Story.findById(id);
    if (!story) {
        return res.status(404).json({
            message: 'story not found',
            error: 'The specified story does not exist'
        });
    }

    Comment.find({Story:id}).populate("User","-password").then((comments)=>{
        res.status(200).json(comments);
    })
    .catch((error) => {
        res.status(404).json({ message: error });
    });

}