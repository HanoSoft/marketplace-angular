import { Component, OnInit } from '@angular/core';
import {FormBuilder, FormGroup, Validators} from '@angular/forms';
import {CustomerService} from '../services/customer.service';
import {Router} from '@angular/router';
import {Customer} from '../models/Customer.model';

@Component({
  selector: 'app-signin',
  templateUrl: './signin.component.html',
  styleUrls: ['./signin.component.scss']
})
export class SigninComponent implements OnInit {

    loginForm: FormGroup;
    msg: string;
    constructor(private formBuilder: FormBuilder,
                private customerService: CustomerService,
                private router: Router) { }

  ngOnInit() {
      this.initForm();
      this.customerService.getCustomers();
  }
    initForm() {
        this.loginForm = this.formBuilder.group({
            email: '',
            pwd: '',
        });
    }
    onSubmitForm() {
        const formValue = this.loginForm.value;
        const auth = this.customerService.signIn( formValue['email'], formValue['pwd']);
       if (auth) {
           window.location.reload();
           this.router.navigate(['']);
       } else {
           this.msg = 'email ou mot de passe invalid';
       }
    }
}
