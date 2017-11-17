# Blog CMS

A Blog CMS base on Ruby on Rails framework, has 3 section:
* **Admin panel** : allow users to CRUD posts(for logged users), users(for super admin)
* **Front panel** : allow visitors to view, sort post list, comment(for logged user)
* **REST API** : RESTful api for retrieve posts (with search)

[Live page](https://tien7668-blog.herokuapp.com)
### Local Installing and Usage

Step 1: clone this project

Step 2: install dependencies

```
bundle install
```

Step 3: migrate db

Create local postgrs db my_blog_dev, then run
```
rake db:migrate
```

Step 3: seed db (default users, posts):
* **admin account** : super_admin@gmail.com | 123456
* **user accounts** : user_0@gmail.com ... user_9@gmail.com | 123456

```
rake db:seed
```
