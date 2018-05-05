import { Component, OnInit } from '@angular/core';
import {FormBuilder, FormGroup} from '@angular/forms';
import {Address} from '../models/Address.model';
import {AddressService} from '../services/address.service';

@Component({
  selector: 'app-adress',
  templateUrl: './adress.component.html',
  styleUrls: ['./adress.component.scss']
})
export class AdressComponent implements OnInit {
    addressForm: FormGroup;
  constructor(private formBuilder: FormBuilder, private addressService: AddressService) { }

  ngOnInit() {
      this.initForm();
  }
    initForm() {
        const name = localStorage.getItem('name');
        const familyName = localStorage.getItem('familyName');
        const phoneNumber = localStorage.getItem('phoneNumber');
        this.addressForm = this.formBuilder.group({
            customerName: name,
            familyName: familyName,
            phoneNumber: phoneNumber,
            country: '',
            city: '',
            address: '',
            name: '',
            postal_code: ''
        });
    }
    onSubmitForm() {
        const formValue = this.addressForm.value;
        const address = new Address(
            formValue['country'],
            formValue['city'],
            formValue['address'],
            formValue['name'],
            formValue['postal_code']
        );
        this.addressService.add(address) ;
        /* this.router.navigate(['']);*/
    }

}
