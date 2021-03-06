import React, {Component} from 'react';
import Layout from "../../components/Layout";
import {Form,Button,Input,Message} from "semantic-ui-react";
import factory from "../../ethereum/factory";
import web3 from "../../ethereum/web3";
import {Router} from "../../routes";



class CampaignNew extends Component{

state={
  description:'',
  errorMessage:'',
  loading: false,
};

onSubmit=async (event)=>{
  event.preventDefault();
  this.setState({loading: true, errorMessage:""});
  try{
  const accounts=await web3.eth.getAccounts();
  await factory.methods
  .createKaizen(this.state.description)
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
      <h3>Create a Kaizen</h3>
      <Form onSubmit={this.onSubmit} error={!!this.state.errorMessage}>
      <Form.Field>
      <label>Description of the proposed Kaizen</label>
      <Input

      label="."
      labelPosition="right"
      value={this.state.description}
      onChange={event=>
      this.setState({description:event.target.value})} />

      </Form.Field>
      <Message error header="Oops!" content={this.state.errorMessage} />
      <Button loading={this.state.loading} primary>Create!</Button>
      </Form>
      </Layout>
    );
  }
}

export default CampaignNew;
