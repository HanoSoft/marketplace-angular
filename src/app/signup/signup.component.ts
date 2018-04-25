import { Component, OnInit } from '@angular/core';
import {CustomerService} from '../services/customer.service';
import {FormBuilder, FormGroup, FormControl, Validators} from '@angular/forms';
import {Customer} from '../models/Customer.model';
import {Router} from '@angular/router';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.scss']
})
export class SignupComponent implements OnInit {
    customerForm: FormGroup;
    constructor(private formBuilder: FormBuilder,
                private customerService: CustomerService,
                private router: Router) { }

    ngOnInit() {
        this.initForm();
    }

    initForm() {
        this.customerForm = this.formBuilder.group({
            name: ['', [Validators.required, Validators.minLength(3)]],
            familyName: ['', [Validators.required, Validators.minLength(3)]],
            email: ['', [Validators.required, Validators.email]],
            pwd: ['', [Validators.required, Validators.minLength(8), Validators.pattern('^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$')]],
            sponsorCode: '',
        });
    }
    onSubmitForm() {
        const formValue = this.customerForm.value;
        const newCustomer = new Customer(
            formValue['name'],
            formValue['pwd'],
            formValue['familyName'],
            formValue['email'],
            formValue['sponsorCode'],
           );
        this.customerService.addCustomer(newCustomer) ;
        this.router.navigate(['']);
    }

}
