The xcode tool project is planed to be a collection of xcode tools.

Now, it contains the following tools:

####1. Code snippets management.

It is used for managing the snippets in xcode.

The default snippets are stored in the ~/Library/Developer/Xcode/UserData/CodeSnippets/

We can check out this git project and use a soft link to the target directory.

Usage:

	1. check out the project using: git clone https://github.com/tangqiaoboy/xcode_tool
	2. cd xcode_tool
	3. ./setup_snippets.sh
