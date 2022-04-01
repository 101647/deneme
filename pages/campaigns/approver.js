import React, {Component} from 'react';
import Layout from "../../components/Layout";
import {Form,Button,Input,Message} from "semantic-ui-react";
import factory from "../../ethereum/factory";
import web3 from "../../ethereum/web3";
import {Router} from "../../routes";



class ApproverNew extends Component{

state={
  address:'',
  errorMessage:'',
  loading: false,
};

onSubmit=async (event)=>{
  event.preventDefault();
  this.setState({loading: true, errorMessage:""});
  try{
  const accounts=await web3.eth.getAccounts();
  await factory.methods
  .addApprover(this.state.address)
  .send({
    from:accounts[0]

  });
  Router.pushRoute('/');
} catch(err){
  this.setState({errorMessage:err.message});
}
this.setState({loading: false});

};

  render(){
    return (
      <Layout>
      <h3>Add an Approver</h3>
      <Form onSubmit={this.onSubmit} error={!!this.state.errorMessage}>
      <Form.Field>
      <label>ETH Address of the approver</label>
      <Input

      label="."
      labelPosition="right"
      value={this.state.address}
      onChange={event=>
      this.setState({address:event.target.value})} />

      </Form.Field>
      <Message error header="Oops!" content={this.state.errorMessage} />
      <Button loading={this.state.loading} primary>Add!</Button>
      </Form>
      </Layout>
    );
  }
}

export default ApproverNew;
