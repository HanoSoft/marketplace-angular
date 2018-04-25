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
            email: ['', [Validators.required, Validators.email]],
            pwd: ['', [Validators.required, Validators.minLength(8), Validators.pattern('^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$')]],
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
