
import {ShopingService} from '../services/shoping.service';
import {Router} from '@angular/router';
import {Component, Input, OnInit} from '@angular/core';
import {TopNavComponent} from '../top-nav/top-nav.component';
import {Shoping} from '../models/Shoping';
import {Subscription} from 'rxjs/Subscription';
import {Subject} from 'rxjs/Subject';
import {forEach} from '@angular/router/src/utils/collection';
import {FormBuilder, FormGroup, Validators} from '@angular/forms';
import {DATE} from 'ngx-bootstrap/chronos/units/constants';

@Component({
    providers: [TopNavComponent ],
  selector: 'app-product',
  templateUrl: './product.component.html',
  styleUrls: ['./product.component.scss']
})
export class ProductComponent implements OnInit {
    products = [] ;
    date: Date;
    @Input() id: number;
    @Input() deleted: boolean;
    @Input()  productName: string ;
    @Input() description: string;
    @Input() price: number;
    @Input() quantity: number ;
    @Input() images = [];
    @Input() sizes = [];
    @Input() promotions = [];
    public subscription: Subscription;
    private val: Subject <any>;
    basket ;
    selected = false;
    itemForm: FormGroup;
    url = 'http://localhost:8888/pfe_marketplace/web/uploads/product/';
  constructor(private shoping: ShopingService, private route: Router, private formBuilder: FormBuilder) {
      this.basket = this.shoping.getProducts();
  }
  ngOnInit() {
      this.date = new Date();
      for (const b of this.basket) {
          if (this.id === b.id) {
              this.selected = true;
          }
      }
    /*  this.initForm();*/
  }
  onAdd(id, price , name, image) {
     /* const formValue = this.itemForm.value;*/

      this.shoping.AddToBasket(id, price , name, image, 1, 'xs');
      this.selected = true;
      this.basket = this.shoping.getProducts();
  }
    public onDelete(id, price) {
        this.shoping.remove(id, price);
        this.selected = false;
        this.basket = this.shoping.getProducts();
    }
   /* initForm() {
      const size = this.sizes[0].size;
        this.itemForm = this.formBuilder.group({
            size: [size, [Validators.required]]
        });
    }*/
}
