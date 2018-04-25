import { Injectable } from '@angular/core';
import {Subject} from 'rxjs/Subject';
import {HttpClient} from '@angular/common/http';

@Injectable()
export class ProductService {
    productSubject = new Subject<any[]>();
    private products = [];
    constructor(private httpClient: HttpClient) { }
    public emitProductSubject() {
        this.productSubject.next(this.products.slice());
    }
    public getProducts () {
        this.httpClient.get<any[]>('http://localhost:8888/pfe_marketplace/web/app_dev.php/api/products').subscribe(
            (response) => {this.products = response;
                this.emitProductSubject();
            },
            (error) => {console.log('Erreur ! :' + error); }
        );
    }
    getProduct (id: number) {
        this.getProducts();
        const product = this.products.find((productObject) => {
            return productObject.id === id; });
        console.log('ok' + id);
        return product;
    }
}
