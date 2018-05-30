import { Component, OnInit } from '@angular/core';
import {Router} from '@angular/router';
import {FormBuilder, FormControl, FormGroup, Validators} from '@angular/forms';
import {CustomerService} from '../services/customer.service';
import {CustomerProfile} from '../models/CustomerProfile.mpodel';
import {UpdateEmail} from '../models/UpdateEmail';
import {UpdatePassword} from '../models/UpdatePassword.model';
import {emailMatcher} from './email-matcher';
import {passwordMatcher} from './password-matcher';
import * as sha1 from 'js-sha1';


@Component({
  selector: 'app-customer-profile',
  templateUrl: './customer-profile.component.html',
  styleUrls: ['./customer-profile.component.scss']
})
export class CustomerProfileComponent implements OnInit {
    customerForm: FormGroup;
    emailForm: FormGroup;
    pwdForm: FormGroup;
    id = localStorage.getItem('id');
    msg: string;
    msgPwd: string;
    password = localStorage.getItem('pwd');
    progressbar = '100%;';
    constructor(private formBuilder: FormBuilder,
                private customerService: CustomerService,
                private router: Router) { }
    ngOnInit() {
        this.initForm();
        this.initEmailForm();
        this.initPwdForm();
    }

     initForm() {
         const name = localStorage.getItem('name');
         const familyName = localStorage.getItem('familyName');
         const birthDate = localStorage.getItem('birthDate');
         const phoneNumber = localStorage.getItem('phoneNumber');
         const email = localStorage.getItem('email');
         const sex = localStorage.getItem('sex');
         this.customerForm = this.formBuilder.group({
             name: name,
             familyName: familyName,
             email: email,
             birthDate: birthDate,
             phoneNumber: phoneNumber,
             sex: sex
        });
     }
    onSubmitForm() {
        const formValue = this.customerForm.value;
        const newCustomer = new CustomerProfile(
            formValue['name'],
            formValue['familyName'],
            formValue['email'],
            formValue['birthDate'],
            formValue['phoneNumber']
           );

        this.customerService.editCustomer(+this.id, newCustomer) ;
        this.progressbar = 'width: 100%;';
      /* this.router.navigate(['']);*/
    }
    initEmailForm() {
        this.emailForm = this.formBuilder.group({
            email: localStorage.getItem('email'),
            password: ['', [Validators.required] ],
            newEmail: ['', [Validators.required, Validators.email]],
            confirmEmail:   ['', [Validators.required, Validators.email]]
        }, { validator: emailMatcher }
        );
    }
    onSubmitEmailForm() {
        const formValue = this.emailForm.value;
        const newCustomer = new UpdateEmail(
            formValue['newEmail'],
        );
        this.customerService.updateEmail(+this.id, newCustomer) ;
        }
    initPwdForm() {
        this.pwdForm = this.formBuilder.group({
                password: ['', [Validators.required] ],
                newPassword: ['', [Validators.required, Validators.minLength(8),
                    Validators.pattern('^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$')]],
                confirmPwd:   ['', [Validators.required]]
            }, { validator: passwordMatcher }
        );
    }
    onSubmitPwdForm() {
        const formValue = this.pwdForm.value;
        const newCustomer = new UpdatePassword(
            sha1(formValue['newPassword']),
        );
        this.customerService.updatePwd(+this.id, newCustomer) ;
    }
    onchange() {
        if (this.emailForm.value.password !== localStorage.getItem( 'pwd')) {
           this.msg = 'mot de passe erroné' ;
        } else {
            this.msg = '';
        }
    }
    onPwdchange() {
        if (this.pwdForm.value.password !== localStorage.getItem( 'pwd')) {
            this.msgPwd = 'mot de passe erroné' ;
        } else {
            this.msgPwd = '';
        }
    }
}
