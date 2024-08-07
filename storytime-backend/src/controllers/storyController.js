const { ObjectId } = require("mongodb");
const Story = require('../models/story');
const User = require('../models/user')



module.exports.getAllStories = async function (req, res) {
    Story.find().populate("Owner", "-password")
        .then((Stories) => {
            res.status(200).json(Stories);
        })
        .catch((error) => res.status(404).json({ message: error }));
};


module.exports.getStoryById = async function (req, res) {
    try {
        const storyId = req.params.id;

        const story = await Story.findById(storyId)
            .populate('Owner', '-password'); // Populate Owner with fullName and image
            // .populate({
            //     path: 'Comments',
            //     populate: {
            //         path: 'User',
            //         select: 'fullName image' // Populate User in Comments with fullName and image
            //     }
            // });

        if (!story) {
            return res.status(404).json({
                message: 'Story not found',
                error: 'The specified story does not exist'
            });
        }

        res.status(200).json(story);
    } catch (error) {
        res.status(500).json({
            message: 'Error retrieving story',
            error: error.message
        });
    }
};

module.exports.getSharedStories = async function (req, res) {
    Story.find({ isShared:true }).populate("Owner", "-password")
        .then((Stories) => {
            res.status(200).json(Stories);
        })
        .catch((error) => res.status(404).json({ message: error }));
};

module.exports.getStoriesByUser = async function (req, res) {
    const userId = req.params.id;

    const user = await User.findById({ _id: userId });

    Story.find({ Owner: user._id })
        .populate("Owner", "-password")    
        .then((stories) => {
            res.status(200).json(stories);
        })

        .catch((error) => {
            res.status(404).json({ message: error });
        });
};


module.exports.createStory = async function (req, res) {
    try {
        // Extract data from request body
        const { title, story, ownerId } = req.body;

        // Check if ownerId exists in User collection
        const existingUser = await User.findById(ownerId);
        if (!existingUser) {
            return res.status(404).json({
                message: 'Owner not found',
                error: 'The specified owner does not exist'
            });
        }

        const newStory = new Story({
            Title: title,
            Story: story,
            Owner: ownerId
        });

        await newStory.save();

        res.status(201).json({
            message: 'Story created successfully',
            story: newStory
        });
    } catch (error) {
        // Handle errors
        res.status(500).json({
            message: 'Error creating story',
            error: error.message
        });
    }
};


module.exports.shareStory = async function(req, res) {
    const id = req.params.id;

    try {

        // Update the story and set isShared to true
        const updatedStory = await Story.findByIdAndUpdate(id, { $set: { "isShared": true } }, { new: true });

        if (!updatedStory) {
            return res.status(404).json({
                message: 'Story not found',
                error: 'The specified story ID does not exist'
            });
        }

        res.status(200).json({
            message: 'Story shared successfully',
            story: updatedStory
        });
    } catch (error) {
        res.status(500).json({
            message: 'Error sharing story',
            error: error.message
        });
    }
};


module.exports.likeStory = async function (req, res) {
    const ID = req.params.id;
    const userId = req.body.userId;

    // if (!mongoose.Types.ObjectId.isValid(ID)) {
    //     return res.status(404).json("ID is not valid");
    // }

    // if (!mongoose.Types.ObjectId.isValid(userId)) {
    //     return res.status(404).json("User ID is not valid");
    // }

    try {
        const story = await Story.findByIdAndUpdate(
            ID,
            { $addToSet: { Likes: userId } }, // Add the user ID to the Likes array
            { new: true } // Return the updated document
        );

        if (!story) {
            return res.status(404).json("Story not found");
        }

        return res.status(200).json(story);
    } catch (err) {
        return res.status(500).json({ error: err.message });
    }
};


module.exports.removeLike = async function (req,res) {
    const ID = req.params.id;
    const userId = req.body.userId;

    // if (!mongoose.Types.ObjectId.isValid(ID)) {
    //     return res.status(404).json("ID is not valid");
    // }

    // if (!mongoose.Types.ObjectId.isValid(userId)) {
    //     return res.status(404).json("User ID is not valid");
    // }
    try {
        const story = await Story.findByIdAndUpdate(
            ID,
            { $pull: { Likes: userId } }, // remove the user ID from the Likes array
            { new: true } // Return the updated document
        );

        if (!story) {
            return res.status(404).json("Story not found");
        }

        return res.status(200).json(story);
    } catch (err) {
        return res.status(500).json({ error: err.message });
    }

}

module.exports.deleteStory = async function (req, res) {
    const ID = req.params.id;

    if (!ObjectId.isValid(ID)) {
        return res.status(404).json("ID is not valid");
    }
    try {
        const story = await Story.findByIdAndRemove({ _id: ID });
        if (story) {
            res.status(200).json({ message: "Story deleted succefully" });
        }
    } catch (error) {
        res.status(500).json({ message: error });
    }
};
