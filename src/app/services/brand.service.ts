import { Injectable } from '@angular/core';
import {Subject} from 'rxjs/Subject';
import {HttpClient} from '@angular/common/http';

@Injectable()
export class BrandService {
  brandSubject = new Subject<any[]>();
  private brands = [];
    constructor(private httpClient: HttpClient) { }
  public emitBrandSubject() {
      this.brandSubject.next(this.brands.slice());
  }
  public getBrands () {
      this.httpClient.get<any[]>('http://localhost:8888/pfe_marketplace/web/app_dev.php/api/brands').subscribe(
          (response) => {this.brands = response;
          this.emitBrandSubject();
          },
          (error) => {console.log('Erreur ! :' + error); }
      );
  }
    getBrand (id: number) {
        const brand = this.brands.find((brandObject) => {
            return brandObject.id === id; });
        console.log('ok' + id);
        return brand;
    }
}
