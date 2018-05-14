import { Component, OnInit } from '@angular/core';
import {FormBuilder, FormGroup, Validators} from '@angular/forms';
import {Address} from '../models/Address.model';
import {AddressService} from '../services/address.service';
import {Router} from '@angular/router';

@Component({
  selector: 'app-adress',
  templateUrl: './adress.component.html',
  styleUrls: ['./adress.component.scss']
})
export class AdressComponent implements OnInit {
    addressForm: FormGroup;
  constructor(private formBuilder: FormBuilder, private addressService: AddressService,
              private router: Router ) { }

  ngOnInit() {
      this.initForm();
  }
    initForm() {
        const name = localStorage.getItem('name');
        const familyName = localStorage.getItem('familyName');
        const phoneNumber = localStorage.getItem('phoneNumber');
        const address = JSON.parse(localStorage.getItem('address'));
    console.log( 'adresse ' + address);
        this.addressForm = this.formBuilder.group({
            customerName: name,
            familyName: familyName,
            phoneNumber: phoneNumber,
            country: [address.country, Validators.required],
            city: [address.city, Validators.required],
            address: [address.address, Validators.required],
            name: [address.name, Validators.required],
            postal_code: [address.postal_code, Validators.required],
        });
    }
    onSubmitForm() {
        const customerId = localStorage.getItem('id');
        const formValue = this.addressForm.value;
        const address = new Address(
            formValue['country'],
            formValue['city'],
            formValue['address'],
            formValue['name'],
            formValue['postal_code']
        );
        this.addressService.add(address) ;
         this.router.navigate(['payment']);
    }

}
