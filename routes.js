const routes=require('next-routes')();

routes
.add("/campaigns/new","/campaigns/new")
.add("/campaigns/approver","/campaigns/approver")
.add("/campaigns/approver_delete","/campaigns/approver_delete")
.add("/campaigns/approverList","/campaigns/approverList")
.add("/campaigns/:address","/campaigns/show")
.add("/campaigns/:address/requests","/campaigns/requests/index")
.add("/campaigns/:address/requests/new","/campaigns/requests/new");

module.exports=routes;
