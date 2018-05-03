import { Injectable } from '@angular/core';
import {Subject} from 'rxjs/Subject';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {Customer} from '../models/Customer.model';

@Injectable()
export class CustomerService {
    customerSubject = new Subject<any[]>();
    private customers = [] ;
     isAuth = false;
    constructor(private httpClient: HttpClient) { }
    public emitCustomerSubject() {
        this.customerSubject.next(this.customers.slice());
    }
    public getCustomers () {
        this.httpClient.get<any[]>('http://localhost:8888/pfe_marketplace/web/app_dev.php/api/customers').subscribe(
            (response) => {this.customers = response;
                this.emitCustomerSubject();
            },
            (error) => {console.log('Erreur ! :' + error); }
        );
    }
    saveCustomerToServer(body: any) {
        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/customers';
        const b = JSON.stringify(body);
        this.httpClient.post(url, b, {
            headers: {'Content-Type': 'application/json'}
        })
            .subscribe(
                () => {}, (error) => {console.log( b + 'erreur' + error); }
            );
    }
    addCustomer(customer: Customer) {
        this.customers.push(customer);
        this.emitCustomerSubject();
        this.saveCustomerToServer(customer);
    }
    signIn(email: string, pwd: string) {
        this.getCustomers();
        const customer = this.customers.find((customerObject) => {
            return (customerObject.email === email && customerObject.pwd === pwd ); });
        if (customer) {
            this.isAuth = true;
            localStorage.setItem('isAuth', 'true');
            localStorage.setItem('id', customer.id);
            localStorage.setItem('name', customer.name);
            localStorage.setItem('familyName', customer.family_name);
            localStorage.setItem('email', customer.email);
            localStorage.setItem('sponsorCode', customer.sponsor_code);
            localStorage.setItem('birthDate', customer.birth_date);
            localStorage.setItem('phoneNumber', customer.phone_number);
            localStorage.setItem('pwd', pwd);
            return true;
        } else {return false; }
    }
    getCustomer(id: number) {
        this.getCustomers();
        const customer = this.customers.find((customerObject) => {
            return (customerObject.id === id);
        });
        console.log('ok' + id);
        return customer;
    }
    editCustomerToServer(body: any) {
        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/customers/edit';
        const b = JSON.stringify(body);
        this.httpClient.put(url, b, {
            headers: {'Content-Type': 'application/json'}
        })
            .subscribe(
                () => {}, (error) => {console.log( b + 'erreur' + error); }
            );
    }
    editCustomer (id: number, newCustomer) {
        this.getCustomers();
        newCustomer.id = id;
        localStorage.setItem('id', newCustomer.id);
        localStorage.setItem('name', newCustomer.name);
        localStorage.setItem('familyName', newCustomer.family_name);
        localStorage.setItem('email', newCustomer.email);
        localStorage.setItem('sponsorCode', newCustomer.sponsor_code);
        localStorage.setItem('birthDate', newCustomer.birth_date);
        localStorage.setItem('phoneNumber', newCustomer.phone_number);
        this.editCustomerToServer(newCustomer);
        console.log(newCustomer);
    }
    updateEmail (id: number, newCustomer) {
        this.getCustomers();
        newCustomer.id = id;
        localStorage.setItem('id', newCustomer.id);
        localStorage.setItem('email', newCustomer.email);
        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/customers/edit/email';
        const b = JSON.stringify(newCustomer);
        this.httpClient.put(url, b, {
            headers: {'Content-Type': 'application/json'}
        })
            .subscribe(
                () => {}, (error) => {console.log( b + 'erreur' + error); }
            );
    }
    updatePwd (id: number, newCustomer) {
        this.getCustomers();
        newCustomer.id = id;
        localStorage.setItem('id', newCustomer.id);
        localStorage.setItem('pwd', newCustomer.pwd);
        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/customers/edit/pwd';
        const b = JSON.stringify(newCustomer);
        this.httpClient.put(url, b, {
            headers: {'Content-Type': 'application/json'}
        })
            .subscribe(
                () => {}, (error) => {console.log( b + 'erreur' + error); }
            );
    }
}
