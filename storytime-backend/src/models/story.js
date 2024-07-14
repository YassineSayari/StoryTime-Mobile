const mongoose = require("mongoose");


const StorySchema = new mongoose.Schema({

    Title: { type: String, required: true },
    Story:{ type: String, required: true },
    Date: { type: Date, default: Date.now },
    isShared: { type: Boolean, default: false },
    Owner: { type: mongoose.Types.ObjectId, ref: "User" },
    Likes: [{ type: mongoose.Types.ObjectId, ref: "User" }],
    //Comments: [{type: mongoose.Types.ObjectId, ref : "Comment"}],
});

module.exports = mongoose.model("Story", StorySchema);