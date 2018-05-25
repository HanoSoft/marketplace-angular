import { Injectable } from '@angular/core';
import {Subject} from 'rxjs/Subject';
import {HttpClient} from '@angular/common/http';
import {Address} from '../models/Address.model';

@Injectable()
export class AddressService {
    addressSubject = new Subject<any[]>();
    private addresses = [] ;
    constructor(private httpClient: HttpClient) { }
    public emitAddressSubject() {
        this.addressSubject.next(this.addresses.slice());
    }
    saveToServer(body: any) {
        const customerId = localStorage.getItem('id');
        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/customers/addresses/' + customerId;
        const b = JSON.stringify(body);
        localStorage.setItem('address', b);

        this.httpClient.post(url, b, {
            headers: {'Content-Type': 'application/json'}
        })
            .subscribe(
                () => {}, (error) => {console.log( b + 'erreur' + error); }
            );
    }
    /*add new address*/
    add(address: Address) {
        this.addresses.push(address);
        this.emitAddressSubject();
        this.saveToServer(address);
    }
}
