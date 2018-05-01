import { Component, OnInit } from '@angular/core';
import {Router} from '@angular/router';
import {FormBuilder, FormGroup, Validators} from '@angular/forms';
import {CustomerService} from '../services/customer.service';
import {CustomerProfile} from '../models/CustomerProfile.mpodel';

@Component({
  selector: 'app-customer-profile',
  templateUrl: './customer-profile.component.html',
  styleUrls: ['./customer-profile.component.scss']
})
export class CustomerProfileComponent implements OnInit {
    customerForm: FormGroup;
    id = localStorage.getItem('id');
    constructor(private formBuilder: FormBuilder,
                private customerService: CustomerService,
                private router: Router) { }
    ngOnInit() {
        this.initForm();
    }

     initForm() {
         const name = localStorage.getItem('name');
         const familyName = localStorage.getItem('familyName');
         const email = localStorage.getItem('email');
         const birthDate = localStorage.getItem('birthDate');
         const phoneNumber = localStorage.getItem('phoneNumber');
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
            formValue['phoneNumber'],
            formValue['sex']);

        this.customerService.editCustomer(+this.id, newCustomer) ;
      /* this.router.navigate(['']);*/
    }
}
