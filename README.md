# egsl-website-api
This repo includes the Ruby on Rails api which serves as backend for the EgSL website.

## Getting started
To get your repo up and running you will need to install [docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/).

Then run the following 3 commands (You may need to `sudo`):
```bash
  docker-compose build
  docker-compose run web rails db:schema:load
  docker-compose up
  ```
1. **`docker-compose build`** builds the docker container which contains all the project's actual dependencies and a bunch of other utilities, so it may take a while the first time, and anytime you break it really really badly.
2. **`docker-compose run web rails db:schema:load`** this creates the database and all the tables we have in it so far
3. **`docker-compose up`** this brings the server up and any other needed background services

If all everything went well, the terminal should say "Listening on port 3000" or something of that sort which means the server is running. If you open your browser and go to `localhost:3000` you should see a Not Found response.

If you go to `localhost:1080`, you should see the mailcatcher interface which we will use to see the mails our api sends in the development environment. (such as signup confirmation, etc.)

## Notes for development
### Debugging
If you intend to use an interactive debugger (pry or byebug, etc.), instead of `docker-compose up` in step 3, you should run these two commands in succession:
  ```bash
  docker-compose up -d
  docker attach egsl-website-api_web_1
  ```
### Rails commands
If you're new to Docker, you should know that the rails env won't be available outside the container. So any rails commands (`rails c`, `rails g`, `rails db:migrate`, etc.), or any command dependent on the gemfile installed won't work outside the container, because they weren't installed outside. Instead you need to use `docker-compose exec web bash` to open a bash shell inside your container to be able to run all the rails commands you're used to. 

### Dependencies
All our dependencies should be listed in `Gemfile`. When adding a new dependency, you'll need to rebuild the docker container as follows.
```bash
docker-compose up --build
```
Docker may eat up your disk space if you aren't careful. Commands such as `docker images` and `docker ps -l` will be useful to know what to remove, in case the rebuilds don't clean up after themselves.

### Permissions
Using docker with rails on linux was a bit of a headache regarding file permissions and file ownership. For now, just `sudo` any of the commands that need extra permissions (the 3 commands in getting started may reply with permission denied), until we figure out a better solution. This hopefully shouldn't be any problem for macos or windows.

(I hope I got the terminology right there)

### Play nice with Rubocop
The environment set up will automatically place a pre-commit hook that will run stylistic checks on the whole codebase before you commit. It's really recommended you use rubocop as plugin for the text editor you use, to be able to fix the style issues faster. This is to keep the code as consistent as possible.
