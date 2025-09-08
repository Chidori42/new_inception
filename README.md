# Inception

Instruction	Description
FROM <image>	    Defines a base for your image.
RUN <command>	    Executes any commands in a new layer on top of the current image and commits the result. RUN also has a shell form for running commands.
WORKDIR <directory>	Sets the working directory for any RUN, CMD, ENTRYPOINT, COPY, and ADD instructions that follow it in the Dockerfile.
COPY <src> <dest>	Copies new files or directories from <src> and adds them to the filesystem of the container at the path <dest>.
CMD <command>	    Lets you define the default program that is run once you start the container based on this image. Each Dockerfile only has one CMD, and only the last CMD instance is respected when multiple exist.
# new_inception
