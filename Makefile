BRANCH=master

api:
	cd api && mix phx.server

front:
	cd front && npm start

deploy-api:
	git push api-production `git subtree split --prefix api ${BRANCH}`:master

deploy-front:
	git push front-production `git subtree split --prefix front ${BRANCH}`:master

.PHONY: api front
