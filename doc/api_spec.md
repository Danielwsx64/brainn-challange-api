

# Group User Repositories


## User Repositories [/users/:id/repositories]


### Get user`s repositories [GET /api/v1/users/{user_id}/repositories]

+ Parameters
    + user_id: `764` (number, required)

+ Request returns user`s repositories
**GET**&nbsp;&nbsp;`/api/v1/users/764/repositories`

    + Headers

            Accept: application/json

+ Response 200

    + Headers

            Content-Type: application/json; charset=utf-8

    + Body

            [
              {
                "id": 883,
                "github_id": 1,
                "name": "repo_name",
                "description": "my awesome repo",
                "html_url": "https://github.com/user/repo",
                "language": "assembly",
                "user_id": 764,
                "tags": [
                  {
                    "name": "tag_1"
                  },
                  {
                    "name": "tag_2"
                  }
                ]
              },
              {
                "id": 884,
                "github_id": 1,
                "name": "repo_name",
                "description": "my awesome repo",
                "html_url": "https://github.com/user/repo",
                "language": "assembly",
                "user_id": 764,
                "tags": [
                  {
                    "name": "tag_1"
                  },
                  {
                    "name": "tag_2"
                  }
                ]
              }
            ]

### Update repository tags [PATCH /api/v1/users/{user_id}/repositories/{id}]

+ Parameters
    + user_id: `765` (number, required)
    + id: `885` (number, required)

+ Request updates repository tags
**PATCH**&nbsp;&nbsp;`/api/v1/users/765/repositories/885`

    + Headers

            Accept: application/json
            Content-Type: application/x-www-form-urlencoded

    + Body

            repository[tags][]=docker&repository[tags][]=devops

+ Response 204

### Search repositories by tag [GET /api/v1/users/{user_id}/repositories/search]

+ Parameters
    + user_id: `766` (number, required)

+ Request search repositories by tag
**GET**&nbsp;&nbsp;`/api/v1/users/766/repositories/search?tag=devops`

    + Headers

            Accept: application/json

+ Response 200

    + Headers

            Content-Type: application/json; charset=utf-8

    + Body

            [
              {
                "id": 886,
                "github_id": 1,
                "name": "devops-stuff",
                "description": "my awesome repo",
                "html_url": "https://github.com/user/repo",
                "language": "assembly",
                "user_id": 766,
                "tags": [
                  {
                    "name": "devops"
                  }
                ]
              }
            ]

# Group Users


## Users [/users]


### Get an user [GET /api/v1/users/{id}]

+ Parameters
    + id: `762` (number, required)

+ Request returns an user
**GET**&nbsp;&nbsp;`/api/v1/users/762`

    + Headers

            Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5

+ Response 200

    + Headers

            Content-Type: application/json; charset=utf-8

    + Body

            {
              "id": 762,
              "name": "user_1"
            }

### Create an user [POST /api/v1/users]


+ Request creates a user
**POST**&nbsp;&nbsp;`/api/v1/users`

    + Headers

            Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5
            Content-Type: application/x-www-form-urlencoded

    + Body

            user[name]=Bill

+ Response 201

    + Headers

            Content-Type: application/json; charset=utf-8

    + Body

            {
              "id": 763,
              "name": "Bill"
            }
