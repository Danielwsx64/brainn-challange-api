

# Group User Repositories


## User Repositories [/users/:id/repositories]


### Get user`s repositories [GET /api/v1/users/{user_id}/repositories]

+ Parameters
    + user_id: `3` (number, required)

+ Request returns user`s repositories
**GET**&nbsp;&nbsp;`/api/v1/users/3/repositories`

    + Headers

            Accept: application/json

+ Response 200

    + Headers

            Content-Type: application/json; charset=utf-8

    + Body

            [
              {
                "id": 1,
                "github_id": 1,
                "name": "repo_name",
                "description": "my awesome repo",
                "html_url": "https://github.com/user/repo",
                "language": "assembly",
                "user_id": 3,
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
                "id": 2,
                "github_id": 1,
                "name": "repo_name",
                "description": "my awesome repo",
                "html_url": "https://github.com/user/repo",
                "language": "assembly",
                "user_id": 3,
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

### Fetch starred repositories [POST /api/v1/users/{user_id}/repositories/fetch]

+ Parameters
    + user_id: `4` (number, required)

+ Request fetch starred repositories
**POST**&nbsp;&nbsp;`/api/v1/users/4/repositories/fetch`

    + Headers

            Accept: application/json
            Content-Type: application/x-www-form-urlencoded

+ Response 201

    + Headers

            Content-Type: application/json; charset=utf-8

    + Body

            [
              {
                "id": 3,
                "github_id": 111328638,
                "name": "crm-filter",
                "description": null,
                "html_url": "https://github.com/Danielwsx64/crm-filter",
                "language": "PHP",
                "user_id": 4
              },
              {
                "id": 4,
                "github_id": 136528251,
                "name": "doctors_api",
                "description": "API written in Elixir to provide services and channels to the doctors-front application",
                "html_url": "https://github.com/ecamalionte/doctors_api",
                "language": "Elixir",
                "user_id": 4
              },
              {
                "id": 5,
                "github_id": 136524424,
                "name": "doctors-front",
                "description": "React application responsible for connecting and rendering doctors-api information.",
                "html_url": "https://github.com/ecamalionte/doctors-front",
                "language": "JavaScript",
                "user_id": 4
              }
            ]

### Update repository tags [PATCH /api/v1/users/{user_id}/repositories/{id}]

+ Parameters
    + user_id: `5` (number, required)
    + id: `6` (number, required)

+ Request updates repository tags
**PATCH**&nbsp;&nbsp;`/api/v1/users/5/repositories/6`

    + Headers

            Accept: application/json
            Content-Type: application/x-www-form-urlencoded

    + Body

            repository[tags][]=docker&repository[tags][]=devops

+ Response 204

### Search repositories by tag [GET /api/v1/users/{user_id}/repositories/search]

+ Parameters
    + user_id: `6` (number, required)

+ Request search repositories by tag
**GET**&nbsp;&nbsp;`/api/v1/users/6/repositories/search?tag=devops`

    + Headers

            Accept: application/json

+ Response 200

    + Headers

            Content-Type: application/json; charset=utf-8

    + Body

            [
              {
                "id": 7,
                "github_id": 1,
                "name": "devops-stuff",
                "description": "my awesome repo",
                "html_url": "https://github.com/user/repo",
                "language": "assembly",
                "user_id": 6,
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
    + id: `1` (number, required)

+ Request returns an user
**GET**&nbsp;&nbsp;`/api/v1/users/1`

    + Headers

            Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5

+ Response 200

    + Headers

            Content-Type: application/json; charset=utf-8

    + Body

            {
              "id": 1,
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
              "id": 2,
              "name": "Bill"
            }
