import {Component , OnInit} from '@angular/core';
import {ActivatedRoute, Router} from '@angular/router';
import {BrandService} from '../services/brand.service';
import {ShopingService} from '../services/shoping.service';
import {FormBuilder, FormGroup, Validators} from '@angular/forms';

@Component({
  selector: 'app-product-details',
  templateUrl: './product-details.component.html',
  styleUrls: ['./product-details.component.scss']
})
export class ProductDetailsComponent implements OnInit {
    brand;
    idc ;
    id;
    idp;
    urlBrand = 'http://localhost:8888/pfe_marketplace/web/uploads/brand/';
    url = 'http://localhost:8888/pfe_marketplace/web/uploads/product/';
    basket ;
    selected = false;
    quantity;
    itemForm: FormGroup;
    constructor(private brandService: BrandService, private router: ActivatedRoute, private shoping: ShopingService,
                private formBuilder: FormBuilder) {
        this.basket = this.shoping.getProducts();
        this.id = this.router.snapshot.params['id'];
        this.idc = +this.router.snapshot.params['idc'];
         this.idp = this.router.snapshot.params['idp'];
        this.brand = this.brandService.getBrand(+this.id);
        for (const b of this.basket) {
            if (this.idp === b.id.toString()) {
                this.selected = true;
            }
        }
    }
    ngOnInit(): void {
        this.initForm();
    }
    onAdd(id, price , name, image, quantity) {
        const formValue = this.itemForm.value;

        this.shoping.AddToBasket(id, price , name, image, +formValue['quantity'], formValue['size']);
        this.selected = true;
        this.basket = this.shoping.getProducts();
    }
    public onDelete(id, price) {
        this.shoping.remove(id, price);
        this.selected = false;
        this.basket = this.shoping.getProducts();
    }
    initForm() {
        this.itemForm = this.formBuilder.group({
            quantity: ['1', [Validators.required]],
            size: [ [Validators.required]]
        });
    }
}
