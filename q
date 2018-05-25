[33mcommit 75bc8e1a16db57c10e749d10657d1b68d4eb2be3[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Fri May 25 14:11:23 2018 +0100

    fix promotion and enabled on product details

[1mdiff --git a/package-lock.json b/package-lock.json[m
[1mindex 776acc7..02fa1f3 100644[m
[1m--- a/package-lock.json[m
[1m+++ b/package-lock.json[m
[36m@@ -6040,6 +6040,11 @@[m
       "dev": true,[m
       "optional": true[m
     },[m
[32m+[m[32m    "js-sha1": {[m
[32m+[m[32m      "version": "0.6.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/js-sha1/-/js-sha1-0.6.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-01gwBFreYydzmU9BmZxpVk6svJJHrVxEN3IOiGl6VO93bVKYETJ0sIth6DASI6mIFdt7NmfX9UiByRzsYHGU9w=="[m
[32m+[m[32m    },[m
     "js-tokens": {[m
       "version": "3.0.2",[m
       "resolved": "https://registry.npmjs.org/js-tokens/-/js-tokens-3.0.2.tgz",[m
[1mdiff --git a/package.json b/package.json[m
[1mindex 1961540..72bf85b 100644[m
[1m--- a/package.json[m
[1m+++ b/package.json[m
[36m@@ -25,6 +25,7 @@[m
     "angular5-social-login": "^1.0.9",[m
     "bootstrap": "^3.3.7",[m
     "core-js": "^2.4.1",[m
[32m+[m[32m    "js-sha1": "^0.6.0",[m
     "ngx-bootstrap": "^2.0.5",[m
     "rxjs": "^5.5.6",[m
     "zone.js": "^0.8.19"[m
[1mdiff --git a/src/app/adress/adress.component.ts b/src/app/adress/adress.component.ts[m
[1mindex cf8d03c..ca73539 100644[m
[1m--- a/src/app/adress/adress.component.ts[m
[1m+++ b/src/app/adress/adress.component.ts[m
[36m@@ -27,7 +27,7 @@[m [mexport class AdressComponent implements OnInit {[m
             customerName: name,[m
             familyName: familyName,[m
             phoneNumber: phoneNumber,[m
[31m-            country: [address.country, Validators.required],[m
[32m+[m[32m            country: ['France', Validators.required],[m
             city: [address.city, Validators.required],[m
             address: [address.address, Validators.required],[m
             name: [address.name, Validators.required],[m
[1mdiff --git a/src/app/app.module.ts b/src/app/app.module.ts[m
[1mindex a5181e7..dca642b 100644[m
[1m--- a/src/app/app.module.ts[m
[1m+++ b/src/app/app.module.ts[m
[36m@@ -47,6 +47,7 @@[m [mconst appRoutes: Routes = [[m
     { path: 'signup', component: SignupComponent},[m
     { path: 'profile', canActivate: [AuthGuard], component: CustomerProfileComponent },[m
     { path: '', component: HomeComponent},[m
[32m+[m[32m    {path: 'not-found', component: NotFoundComponent},[m
     /*basket-list*/[m
     { path: 'basket', component: BasketListComponent},[m
     { path: 'address', canActivate: [AuthGuard], component: AdressComponent},[m
[36m@@ -84,7 +85,6 @@[m [mconst appRoutes: Routes = [[m
     { path: 'jewelry/:id/:idc/:idp',  component: ProductDetailsComponent},[m
 [m
     /*not found*/[m
[31m-    {path: 'not-found', component: NotFoundComponent},[m
     {path: '**', redirectTo: '/not-found'},[m
 [m
 ];[m
[1mdiff --git a/src/app/models/User.model.ts b/src/app/models/User.model.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..fafd968[m
[1m--- /dev/null[m
[1m+++ b/src/app/models/User.model.ts[m
[36m@@ -0,0 +1,5 @@[m
[32m+[m[32mexport class User {[m
[32m+[m[32m    constructor([m
[32m+[m
[32m+[m[32m) {}[m
[32m+[m[32m}[m
[1mdiff --git a/src/app/product-details/product-details.component.html b/src/app/product-details/product-details.component.html[m
[1mindex 45450c7..3572e40 100644[m
[1m--- a/src/app/product-details/product-details.component.html[m
[1m+++ b/src/app/product-details/product-details.component.html[m
[36m@@ -160,8 +160,13 @@[m
     <div class="col-md-8 single-right-left simpleCart_shelfItem">[m
         <h3  style="border-bottom: solid 1px #E9E9E9;border-top: solid 1px #E9E9E9;">{{product.product_name}}</h3>[m
 [m
[31m-        <p><span class="item_price">{{product.price}}€</span> <del>- {{product.price}}€</del></p>[m
[31m-[m
[32m+[m[32m        <p *ngIf="product.promotions.length>0 && product.promotions[0].deleted==false">[m
[32m+[m[32m            <span class="item_price">{{product.price-(product.price*product.promotions[0].discount/100)}} €</span>[m
[32m+[m[32m            <del >- {{product.price}}€</del>[m
[32m+[m[32m        </p>[m
[32m+[m[32m        <p *ngIf="product.promotions.length==0 || product.promotions[0].deleted==true">[m
[32m+[m[32m            <span class="item_price">{{product.price}}</span>[m
[32m+[m[32m        </p>[m
         <div class="color-quality" >[m
             <form [formGroup]="itemForm" (ngSubmit)="onAdd(product.id,product.price,product.product_name,url+product.images[0].name)">[m
             <div class="color-quality-right">[m
[1mdiff --git a/src/app/product/product.component.html b/src/app/product/product.component.html[m
[1mindex d0cb89c..9ac116f 100644[m
[1m--- a/src/app/product/product.component.html[m
[1m+++ b/src/app/product/product.component.html[m
[36m@@ -1,4 +1,5 @@[m
 <div class="col-md-4 product-men" *ngIf="quantity>0">[m
[32m+[m
     <div class="men-pro-item simpleCart_shelfItem" style="min-height:450px;">[m
         <div class="men-thumb-item">[m
             <img [src]="url+images[0].name" alt="" class="pro-image-front">[m
[36m@@ -22,15 +23,6 @@[m
                 <span class="item_price">{{price}} €</span>[m
             </div>[m
 [m
[31m-           <!-- <form [formGroup]="itemForm" (ngSubmit)="onAdd(id,price,productName,url+images[0].name)" *ngIf="sizes.length>0">-->[m
[31m-              <!--  <div  class="form-group">[m
[31m-                        <select class="form-control"  formControlName="size">[m
[31m-                            <option value="{{size.size}}" *ngFor="let size of sizes; let i = index;" >[m
[31m-                                {{size.size}}[m
[31m-                            </option>[m
[31m-                        </select>[m
[31m-                </div>[m
[31m--->[m
             <div class="snipcart-details top_brand_home_details item_add single-item hvr-outline-out button2">[m
 [m
             <input type="submit" name="submit" value="Ajouter au panier" class="button" *ngIf="!selected &&(promotions.length==0||promotions[0].deleted==true)" (click)="onAdd(id,price,productName,url+images[0].name)">[m
[1mdiff --git a/src/app/services/customer.service.ts b/src/app/services/customer.service.ts[m
[1mindex adae068..4652ed6 100644[m
[1m--- a/src/app/services/customer.service.ts[m
[1m+++ b/src/app/services/customer.service.ts[m
[36m@@ -2,7 +2,7 @@[m [mimport { Injectable } from '@angular/core';[m
 import {Subject} from 'rxjs/Subject';[m
 import {HttpClient, HttpHeaders} from '@angular/common/http';[m
 import {Customer} from '../models/Customer.model';[m
[31m-[m
[32m+[m[32mimport * as sha1 from 'js-sha1';[m
 @Injectable()[m
 export class CustomerService {[m
     customerSubject = new Subject<any[]>();[m
[36m@@ -38,7 +38,7 @@[m [mexport class CustomerService {[m
     signIn(email: string, pwd: string) {[m
         this.getCustomers();[m
         const customer = this.customers.find((customerObject) => {[m
[31m-            return (customerObject.email === email && customerObject.pwd === pwd ); });[m
[32m+[m[32m            return (customerObject.email === email && customerObject.pwd === sha1(pwd)) ; });[m
         if (customer) {[m
             this.isAuth = true;[m
             localStorage.setItem('isAuth', 'true');[m
[1mdiff --git a/src/app/signup/signup.component.ts b/src/app/signup/signup.component.ts[m
[1mindex 857ba23..a0ebe1e 100644[m
[1m--- a/src/app/signup/signup.component.ts[m
[1m+++ b/src/app/signup/signup.component.ts[m
[36m@@ -3,6 +3,7 @@[m [mimport {CustomerService} from '../services/customer.service';[m
 import {FormBuilder, FormGroup, FormControl, Validators} from '@angular/forms';[m
 import {Customer} from '../models/Customer.model';[m
 import {Router} from '@angular/router';[m
[32m+[m[32mimport {User} from '../models/User.model';[m
 [m
 @Component({[m
   selector: 'app-signup',[m

[33mcommit 57ce3cb3b1f5304a4e907b029241dee4942c62a0[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Thu May 24 12:03:31 2018 +0100

    create search bar

[1mdiff --git a/src/app/app.module.ts b/src/app/app.module.ts[m
[1mindex 4a9a052..a5181e7 100644[m
[1m--- a/src/app/app.module.ts[m
[1m+++ b/src/app/app.module.ts[m
[36m@@ -39,6 +39,7 @@[m [mimport { LoadingComponent } from './loading/loading.component';[m
 import { ModalModule } from 'ngx-bootstrap/modal';[m
 import { OrdersComponent } from './orders/orders.component';[m
 import { OrderItemsComponent } from './order-items/order-items.component';[m
[32m+[m[32mimport { SearchComponent } from './search/search.component';[m
 [m
 [m
 const appRoutes: Routes = [[m
[36m@@ -56,12 +57,14 @@[m [mconst appRoutes: Routes = [[m
     { path: 'beauty',  component: BeautyComponent},[m
     { path: 'HighTec',  component: HighTecComponent},[m
     { path: 'jewelry',  component: JewelryComponent},[m
[32m+[m[32m    { path: 'search',  component: SearchComponent},[m
     /*single brand*/[m
     { path: ':id',  component: SingleBrandComponent},[m
     { path: 'clothes/:id', component: SingleBrandComponent},[m
     { path: 'beauty/:id',  component: SingleBrandComponent},[m
     { path: 'HighTec/:id',  component: SingleBrandComponent},[m
     { path: 'jewelry/:id',  component: SingleBrandComponent},[m
[32m+[m[32m    { path: 'search/:idp',  component: ProductDetailsComponent},[m
     /*product list */[m
     { path: ':id/all', component: ProductListComponent},[m
     { path: ':id/:idc',  component: ProductListComponent},[m
[36m@@ -116,6 +119,7 @@[m [mconst appRoutes: Routes = [[m
     LoadingComponent,[m
     OrdersComponent,[m
     OrderItemsComponent,[m
[32m+[m[32m    SearchComponent,[m
   ],[m
   imports: [[m
     BrowserModule,[m
[1mdiff --git a/src/app/product-details/product-details.component.html b/src/app/product-details/product-details.component.html[m
[1mindex e06a47f..45450c7 100644[m
[1m--- a/src/app/product-details/product-details.component.html[m
[1m+++ b/src/app/product-details/product-details.component.html[m
[36m@@ -1,3 +1,4 @@[m
[32m+[m[32m<!--[m
 <div *ngFor="let category of brand.categories; let i = index;">[m
 [m
 [m
[36m@@ -100,3 +101,110 @@[m
 </ng-container>[m
 [m
         </div>[m
[32m+[m[32m-->[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m[32m<div class="container"  align="center"  style="margin-top: 2px;">[m
[32m+[m[32m<div class="row" >[m
[32m+[m[32m    <div class=" col-md-4">[m
[32m+[m[32m        <div id='carousel-custom' class='carousel slide ' data-ride='carousel'>[m
[32m+[m[32m            <div class='carousel-outer'>[m
[32m+[m[32m                <div class='carousel-inner ' >[m
[32m+[m[32m                    <ng-container *ngFor="let image of product.images; let i = index;">[m
[32m+[m[32m                        <div class='item active ' *ngIf="i===0">[m
[32m+[m[32m                            <img [src]="url+image.name" data-imagezoom="true" >[m
[32m+[m[32m                        </div>[m
[32m+[m
[32m+[m[32m                        <div class='item' *ngIf="i>0">[m
[32m+[m[32m                            <img [src]="url+image.name" data-imagezoom="true" class="img-responsive">[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                    </ng-container>[m
[32m+[m
[32m+[m[32m                    <a class='left carousel-control' href='#carousel-custom' data-slide='prev'>[m
[32m+[m[32m                        <span class='glyphicon glyphicon-menu-left'></span>[m
[32m+[m[32m                    </a>[m
[32m+[m[32m                    <a class='right carousel-control' href='#carousel-custom' data-slide='next'>[m
[32m+[m[32m                        <span class='glyphicon glyphicon-menu-right'></span>[m
[32m+[m[32m                    </a>[m
[32m+[m[32m                </div>[m
[32m+[m
[32m+[m[32m            </div>[m
[32m+[m
[32m+[m[32m            <ol class='carousel-indicators mCustomScrollbar meartlab' >[m
[32m+[m[32m                <ng-container *ngFor="let image of product.images; let i = index;">[m
[32m+[m[32m                    <li data-target='#carousel-custom' [attr.data-slide-to]='i' class='active' *ngIf="i===0">[m
[32m+[m[32m                        <img [src]="url+image.name" alt='' />[m
[32m+[m[32m                    </li>[m
[32m+[m
[32m+[m[32m                    <li  data-target='#carousel-custom' [attr.data-slide-to]='i' *ngIf="i>0">[m
[32m+[m[32m                        <img [src]="url+image.name" alt='' />[m
[32m+[m[32m                    </li>[m
[32m+[m[32m                </ng-container>[m
[32m+[m
[32m+[m[32m            </ol>[m
[32m+[m[32m        </div>[m
[32m+[m[32m    </div>[m
[32m+[m
[32m+[m
[32m+[m[32m    <img [src] ="urlBrand+brand.logo.name" style="width: 200px;">[m
[32m+[m
[32m+[m
[32m+[m[32m    <div class="col-md-8 single-right-left simpleCart_shelfItem">[m
[32m+[m[32m        <h3  style="border-bottom: solid 1px #E9E9E9;border-top: solid 1px #E9E9E9;">{{product.product_name}}</h3>[m
[32m+[m
[32m+[m[32m        <p><span class="item_price">{{product.price}}€</span> <del>- {{product.price}}€</del></p>[m
[32m+[m
[32m+[m[32m        <div class="color-quality" >[m
[32m+[m[32m            <form [formGroup]="itemForm" (ngSubmit)="onAdd(product.id,product.price,product.product_name,url+product.images[0].name)">[m
[32m+[m[32m            <div class="color-quality-right">[m
[32m+[m[32m               <span *ngIf="product.sizes.length>0">[m
[32m+[m[32m                    <h5 >Taille :</h5>[m
[32m+[m[32m                    <select id="" onchange="" class="frm-field required sect" formControlName="size">[m
[32m+[m[32m                        <option value="{{size.size}}" *ngFor="let size of product.sizes; let i = index;">[m
[32m+[m[32m                            {{size.size}}[m
[32m+[m[32m                        </option>[m
[32m+[m[32m                    </select>[m
[32m+[m[32m                </span>[m
[32m+[m[32m                <h5 style="margin-top: 10px;">Quantité :</h5>[m
[32m+[m[32m                <select id="quantity"  class="frm-field required sect" formControlName="quantity">[m
[32m+[m[32m                    <option value="1">1 </option>[m
[32m+[m[32m                    <option value="2">2 </option>[m
[32m+[m[32m                    <option value="3">3 </option>[m
[32m+[m[32m                    <option value="4">4 </option>[m
[32m+[m[32m                    <option value="5">5 </option>[m
[32m+[m[32m                </select>[m
[32m+[m[32m            </div>[m
[32m+[m
[32m+[m[32m            </form>[m
[32m+[m
[32m+[m[32m        </div>[m
[32m+[m
[32m+[m[32m        <div class="occasion-cart">[m
[32m+[m[32m            <div class="snipcart-details top_brand_home_details item_add single-item hvr-outline-out button2">[m
[32m+[m
[32m+[m
[32m+[m[32m                <input type="submit" name="submit" value="Ajouter au panier" class="button"[m
[32m+[m[32m                       (click)="onAdd(product.id,product.price,product.product_name,url+product.images[0].name)" *ngIf="!selected" >[m
[32m+[m
[32m+[m[32m                <input type="submit" name="submit" value="Supprimer" class="button" (click)="onDelete(product.id,product.price)" *ngIf="selected">[m
[32m+[m
[32m+[m[32m            </div>[m
[32m+[m
[32m+[m[32m        </div>[m
[32m+[m
[32m+[m
[32m+[m[32m    </div>[m
[32m+[m[32m    </div>[m
[32m+[m[32m        <app-horizontal-tab [description]="product.product_details"></app-horizontal-tab>[m
[32m+[m[32m</div>[m
[32m+[m[32m    <br>[m
[41m+[m
[41m+[m
[1mdiff --git a/src/app/product-details/product-details.component.ts b/src/app/product-details/product-details.component.ts[m
[1mindex f2d99df..4685c4a 100644[m
[1m--- a/src/app/product-details/product-details.component.ts[m
[1m+++ b/src/app/product-details/product-details.component.ts[m
[36m@@ -20,18 +20,21 @@[m [mexport class ProductDetailsComponent implements OnInit {[m
     selected = false;[m
     quantity;[m
     itemForm: FormGroup;[m
[32m+[m[32m    product;[m
     constructor(private brandService: BrandService, private router: ActivatedRoute, private shoping: ShopingService,[m
                 private formBuilder: FormBuilder) {[m
         this.basket = this.shoping.getProducts();[m
         this.id = this.router.snapshot.params['id'];[m
         this.idc = +this.router.snapshot.params['idc'];[m
          this.idp = this.router.snapshot.params['idp'];[m
[31m-        this.brand = this.brandService.getBrand(+this.id);[m
[32m+[m[32m       /* this.brand = this.brandService.getBrand(+this.id);*/[m
[32m+[m[32m        this.brand = brandService.getBrandFromProductID(+this.idp);[m
         for (const b of this.basket) {[m
             if (this.idp === b.id.toString()) {[m
                 this.selected = true;[m
             }[m
         }[m
[32m+[m[32m        this.product = this.brandService.getProduct(+this.idp);[m
     }[m
     ngOnInit(): void {[m
         this.initForm();[m
[1mdiff --git a/src/app/search/search.component.html b/src/app/search/search.component.html[m
[1mnew file mode 100644[m
[1mindex 0000000..9b37121[m
[1m--- /dev/null[m
[1m+++ b/src/app/search/search.component.html[m
[36m@@ -0,0 +1,24 @@[m
[32m+[m[32m<div *ngIf="products.length==0">0 article correspond à votre recherche</div>[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m[32m<div class="banner-bootom-w3-agileits">[m
[32m+[m[32m    <div class="container">[m
[32m+[m[32m        <!-- mens -->[m
[32m+[m
[32m+[m[32m        <div class="col-md-8 products-right">[m
[32m+[m[32m            <h5>Produits </h5>[m
[32m+[m[32m            <div class="sort-grid">[m
[32m+[m[32m                <div class="clearfix"></div>[m
[32m+[m[32m            </div>[m
[32m+[m
[32m+[m[32m                <app-product *ngFor="let product of products; let i = index;" [productName]="product.product_name"[m
[32m+[m[32m                             [id]="product.id" [price]="product.price" [quantity]="product.quantity" [images]="product.images"[m
[32m+[m[32m                             [deleted]="product.deleted" [sizes]="product.sizes" [promotions]="product.promotions">[m
[32m+[m[32m                </app-product>[m
[32m+[m
[32m+[m
[32m+[m[32m            <div class="clearfix"></div>[m
[32m+[m[32m        </div>[m
[32m+[m
[32m+[m[32m    </div></div>[m
[1mdiff --git a/src/app/search/search.component.scss b/src/app/search/search.component.scss[m
[1mnew file mode 100644[m
[1mindex 0000000..e69de29[m
[1mdiff --git a/src/app/search/search.component.ts b/src/app/search/search.component.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..c800dbf[m
[1m--- /dev/null[m
[1m+++ b/src/app/search/search.component.ts[m
[36m@@ -0,0 +1,17 @@[m
[32m+[m[32mimport { Component, OnInit } from '@angular/core';[m
[32m+[m[32mimport {BrandService} from '../services/brand.service';[m
[32m+[m
[32m+[m[32m@Component({[m
[32m+[m[32m  selector: 'app-search',[m
[32m+[m[32m  templateUrl: './search.component.html',[m
[32m+[m[32m  styleUrls: ['./search.component.scss'][m
[32m+[m[32m})[m
[32m+[m[32mexport class SearchComponent implements OnInit {[m
[32m+[m[32mproducts;[m
[32m+[m[32m  constructor(private brandService: BrandService) { }[m
[32m+[m[32m  ngOnInit() {[m
[32m+[m[32m      const search = localStorage.getItem('search');[m
[32m+[m[32m    this.products = this.brandService.getProducts(search);[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m}[m
[1mdiff --git a/src/app/services/brand.service.ts b/src/app/services/brand.service.ts[m
[1mindex 4ccee65..401de2e 100644[m
[1m--- a/src/app/services/brand.service.ts[m
[1m+++ b/src/app/services/brand.service.ts[m
[36m@@ -25,4 +25,39 @@[m [mexport class BrandService {[m
         console.log('ok' + id);[m
         return brand;[m
     }[m
[32m+[m[32m    getProducts(search) {[m
[32m+[m[32m        const products = [];[m
[32m+[m[32m        for (const brand of this.brands) {[m
[32m+[m[32m            for (const categorie of brand.categories) {[m
[32m+[m[32m                for (const product of categorie.products) {[m
[32m+[m[32m                    if (product.product_name.match('^' + search + '*')) {[m
[32m+[m[32m                        products.push(product);[m
[32m+[m[32m                    }[m
[32m+[m[32m                }[m
[32m+[m[32m            }[m
[32m+[m[32m        }[m
[32m+[m[32m        return products;[m
[32m+[m[32m    }[m
[32m+[m[32m    getProduct(id: number) {[m
[32m+[m[32m        for (const brand of this.brands) {[m
[32m+[m[32m            for (const categorie of brand.categories) {[m
[32m+[m[32m                for (const product of categorie.products) {[m
[32m+[m[32m                    if (product.id === id) {[m
[32m+[m[32m                       return  product;[m
[32m+[m[32m                    }[m
[32m+[m[32m                }[m
[32m+[m[32m            }[m
[32m+[m[32m        }[m
[32m+[m[32m    }[m
[32m+[m[32m    getBrandFromProductID(id: number) {[m
[32m+[m[32m        for (const brand of this.brands) {[m
[32m+[m[32m            for (const categorie of brand.categories) {[m
[32m+[m[32m                for (const product of categorie.products) {[m
[32m+[m[32m                    if (product.id === id) {[m
[32m+[m[32m                        return  brand;[m
[32m+[m[32m                    }[m
[32m+[m[32m                }[m
[32m+[m[32m            }[m
[32m+[m[32m        }[m
[32m+[m[32m    }[m
 }[m
[1mdiff --git a/src/app/top-nav/top-nav.component.html b/src/app/top-nav/top-nav.component.html[m
[1mindex 39d9647..e416411 100644[m
[1m--- a/src/app/top-nav/top-nav.component.html[m
[1m+++ b/src/app/top-nav/top-nav.component.html[m
[36m@@ -19,14 +19,15 @@[m
         </div>[m
 [m
         <!-- header-bot -->[m
[31m-[m
         <div class="col-md-4 header-middle ">[m
[31m-            <form action="#" method="post">[m
[31m-                <input type="search" name="search" placeholder="Rechercher une marque, un article, une vente..." required="">[m
[31m-                <input type="submit" value=" ">[m
[32m+[m
[32m+[m[32m            <form (ngSubmit)="onSubmit(f)" #f="ngForm">[m
[32m+[m[32m                <input type="search" name="search" id="search" placeholder="Rechercher une marque, un article, une vente..." (input)="onSearch(f)" ngModel>[m
[32m+[m[32m                <input type="submit" value=" " (click)="onSearch(f)">[m
                 <div class="clearfix"></div>[m
             </form>[m
         </div>[m
[32m+[m
         <!-- header-bot -->[m
         <div class="col-md-4 agileits-social top_content">[m
             <ul class="icon-list">[m
[1mdiff --git a/src/app/top-nav/top-nav.component.ts b/src/app/top-nav/top-nav.component.ts[m
[1mindex 2116d36..a326983 100644[m
[1m--- a/src/app/top-nav/top-nav.component.ts[m
[1m+++ b/src/app/top-nav/top-nav.component.ts[m
[36m@@ -1,11 +1,10 @@[m
 import {Component, OnDestroy, OnInit} from '@angular/core';[m
 import {Router} from '@angular/router';[m
 import {ShopingService} from '../services/shoping.service';[m
[31m-import {Shoping} from '../models/Shoping';[m
 import {Subscription} from 'rxjs/Subscription';[m
[31m-import {getTemplate} from 'codelyzer/util/ngQuery';[m
 import {Subject} from 'rxjs/Subject';[m
 import {Observable} from 'rxjs/Observable';[m
[32m+[m[32mimport {NgForm} from '@angular/forms';[m
 [m
 [m
 @Component({[m
[36m@@ -39,4 +38,12 @@[m [mexport class TopNavComponent implements OnInit {[m
                 this.isAuth = value;[m
             });[m
     }[m
[32m+[m[32m    onSubmit(form: NgForm) {[m
[32m+[m[32m       const search = form.value['search'];[m
[32m+[m[32m    }[m
[32m+[m[32m    onSearch(form: NgForm) {[m
[32m+[m[32m        const search = form.value['search'];[m
[32m+[m[32m        localStorage.setItem('search', search);[m
[32m+[m[32m        this.router.navigate(['/search']);[m
[32m+[m[32m    }[m
 }[m

[33mcommit 28d7de9c1df3cbcce400a43ddca08d9737f8e6ef[m
Author: Nouha <nouha.bensalem1992@gmail.com>
Date:   Wed May 23 11:22:14 2018 +0100

    update the delivery style

[1mdiff --git a/src/app/payment/payment.component.html b/src/app/payment/payment.component.html[m
[1mindex 32b209a..028ad8a 100644[m
[1m--- a/src/app/payment/payment.component.html[m
[1m+++ b/src/app/payment/payment.component.html[m
[36m@@ -37,10 +37,10 @@[m
                     <ul class="list-group list-group-header">[m
                         <li class="list-group-item list-group-body">[m
                             <div class="row">[m
[31m-                                <div class="col-lg-3 col-md-3 col-xs-3 text-left" style="color: #2fdab8"><b>Nom</b></div>[m
[31m-                                <div class="col-lg-2 col-md-2 col-xs-2" style="color: #2fdab8"><b>Prix</b></div>[m
[31m-                                <div class="col-lg-2 col-md-2 col-xs-2" style="color: #2fdab8"><b>Adresse</b></div>[m
[31m-                                <div class="col-lg-2 col-md-2 col-xs-2" style="color: #2fdab8"><b>Délai</b></div>[m
[32m+[m[32m                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4  text-left" style="color: #2fdab8"><b>Nom</b></div>[m
[32m+[m[32m                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-left" style="color: #2fdab8; margin-left: 7px;"><b>Prix</b></div>[m
[32m+[m[32m                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-left" style="color: #2fdab8"><b>Adresse</b></div>[m
[32m+[m[32m                                <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-left" style="color: #2fdab8 ;margin-left: 7px;"><b>Délai</b></div>[m
 [m
                             </div>[m
                         </li>[m
[36m@@ -49,19 +49,19 @@[m
                         <li class="list-group-item">[m
                             <div class="row">[m
                                     <div class="row" *ngFor="let delev of delivery; let i = index;">[m
[31m-                                        <div class="col-xs-3 text-left" style="margin-left: 10px;" *ngIf="i==0">[m
[32m+[m[32m                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-left" style="margin-left: 10px;" *ngIf="i==0">[m
                                             <input type="radio" name="delivery" class="pink" (click)="onChecked(delev.id)" checked >&nbsp;{{delev.name}}[m
                                         </div>[m
[31m-                                        <div class="col-xs-3 text-left" style="margin-left: 10px;" *ngIf="i>0">[m
[32m+[m[32m                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-left" style="margin-left: 10px;" *ngIf="i>0">[m
                                             <input type="radio" name="delivery" class="pink" (click)="onChecked(delev.id)"  >&nbsp;{{delev.name}}[m
                                         </div>[m
[31m-                                        <div class="col-xs-2 text-left">[m
[32m+[m[32m                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-left" >[m
                                             <h6><strong>{{delev.price}} €</strong></h6>[m
                                         </div>[m
[31m-                                        <div class="col-xs-2 text-left">[m
[32m+[m[32m                                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-left">[m
                                             <h6><strong>{{delev.address}} </strong></h6>[m
                                         </div>[m
[31m-                                        <div class="col-12 col-sm-12 text-sm-center col-md-4 text-md-right row">[m
[32m+[m[32m                                        <div class="col-lg-1 col-md-1 col-sm-1 col-xs-1 text-left">[m
                                                 <h6><strong>{{delev.delivery_time}} jour</strong></h6>[m
                                         </div>[m
                                     </div>[m

[33mcommit a8cbd7393c39e638075e9c9660afa79bfa66145f[m
Merge: 2170c0d c7bfb88
Author: Nouha <nouha.bensalem1992@gmail.com>
Date:   Wed May 23 10:42:54 2018 +0100

    Merge branch 'master' of https://github.com/HanoSoft/marketplace-angular

[33mcommit c7bfb8898156585080ceebe819bf89e728bf88ca[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Wed May 23 09:49:40 2018 +0100

    update order Component

[1mdiff --git a/src/app/orders/orders.component.html b/src/app/orders/orders.component.html[m
[1mindex 0824556..f5d2be6 100644[m
[1m--- a/src/app/orders/orders.component.html[m
[1m+++ b/src/app/orders/orders.component.html[m
[36m@@ -20,9 +20,9 @@[m
               <div class="row">[m
                 <div *ngFor="let order of orders; let i = index;" >[m
                 <div class="col-xs-3 text-left" style=" ">{{order.status}}</div>[m
[31m-                <div class="col-xs-2" style="">{{order.order_date}}</div>[m
[32m+[m[32m                <div class="col-xs-2" style="">{{order.order_date|date:'dd/MM/yyyy'}}</div>[m
                 <div class="col-xs-2" style="">{{order.amount}} €</div>[m
[31m-                <div class="col-xs-2" style="">{{order.delivery_date}}</div>[m
[32m+[m[32m                <div class="col-xs-2" style="">{{order.delivery_date|date:'dd/MM/yyyy'}}</div>[m
                 <div class="col-xs-offset-10" style=""><button id="cancel-btn" (click)="onDelete(order.id)">annuler</button></div>[m
                 </div>[m
                 </div>[m

[33mcommit 2170c0da566837dcf704b9438b1a6a3ffa0d79d5[m
Author: Nouha <nouha.bensalem1992@gmail.com>
Date:   Tue May 22 15:44:55 2018 +0100

    fix the payment style

[1mdiff --git a/src/app/payment/payment.component.html b/src/app/payment/payment.component.html[m
[1mindex 018200e..32b209a 100644[m
[1m--- a/src/app/payment/payment.component.html[m
[1m+++ b/src/app/payment/payment.component.html[m
[36m@@ -27,53 +27,115 @@[m
     </div>[m
 </div>[m
 <!--breadcrump end-->[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-<div class="container" id="main">[m
[31m-    <h2 class="pink">Livreurs</h2>[m
[32m+[m[32m<div class="container" style="margin-top: 50px;" >[m
[32m+[m[32m    <h4 class="white-w3ls">Mes   <span>Livreurs</span></h4>[m
     <hr>[m
[31m-    <div class="card shopping-cart">[m
[31m-[m
[31m-        <div class="card-body" >[m
[31m-            <form action="">[m
[31m-[m
[31m-[m
[31m-            <div class="row" *ngFor="let delev of delivery; let i = index;">[m
[31m-[m
[31m-                <div class="col-12 text-sm-center col-sm-12 text-md-left col-md-6"  style="margin-top: 10px;" *ngIf="i==0">[m
[31m-                   <input type="radio" name="delivery" class="pink" (click)="onChecked(delev.id)" checked >&nbsp;{{delev.name}}[m
[31m-                    <p >{{delev.address}}</p>[m
[31m-                </div>[m
[31m-                <div class="col-12 text-sm-center col-sm-12 text-md-left col-md-6"  style="margin-top: 10px;" *ngIf="i>0">[m
[31m-                    <input type="radio" name="delivery" class="pink" (click)="onChecked(delev.id)"  >&nbsp;{{delev.name}}[m
[31m-                    <p >{{delev.address}}</p>[m
[32m+[m[32m    <div class="row">[m
[32m+[m[32m        <div class="col-xs-12" style="">[m
[32m+[m[32m            <div class="panel panel-default list-group-panel">[m
[32m+[m[32m                <div class="panel-body">[m
[32m+[m[32m                    <ul class="list-group list-group-header">[m
[32m+[m[32m                        <li class="list-group-item list-group-body">[m
[32m+[m[32m                            <div class="row">[m
[32m+[m[32m                                <div class="col-lg-3 col-md-3 col-xs-3 text-left" style="color: #2fdab8"><b>Nom</b></div>[m
[32m+[m[32m                                <div class="col-lg-2 col-md-2 col-xs-2" style="color: #2fdab8"><b>Prix</b></div>[m
[32m+[m[32m                                <div class="col-lg-2 col-md-2 col-xs-2" style="color: #2fdab8"><b>Adresse</b></div>[m
[32m+[m[32m                                <div class="col-lg-2 col-md-2 col-xs-2" style="color: #2fdab8"><b>Délai</b></div>[m
[32m+[m
[32m+[m[32m                            </div>[m
[32m+[m[32m                        </li>[m
[32m+[m[32m                    </ul>[m
[32m+[m[32m                    <ul class="list-group list-group-body" style="">[m
[32m+[m[32m                        <li class="list-group-item">[m
[32m+[m[32m                            <div class="row">[m
[32m+[m[32m                                    <div class="row" *ngFor="let delev of delivery; let i = index;">[m
[32m+[m[32m                                        <div class="col-xs-3 text-left" style="margin-left: 10px;" *ngIf="i==0">[m
[32m+[m[32m                                            <input type="radio" name="delivery" class="pink" (click)="onChecked(delev.id)" checked >&nbsp;{{delev.name}}[m
[32m+[m[32m                                        </div>[m
[32m+[m[32m                                        <div class="col-xs-3 text-left" style="margin-left: 10px;" *ngIf="i>0">[m
[32m+[m[32m                                            <input type="radio" name="delivery" class="pink" (click)="onChecked(delev.id)"  >&nbsp;{{delev.name}}[m
[32m+[m[32m                                        </div>[m
[32m+[m[32m                                        <div class="col-xs-2 text-left">[m
[32m+[m[32m                                            <h6><strong>{{delev.price}} €</strong></h6>[m
[32m+[m[32m                                        </div>[m
[32m+[m[32m                                        <div class="col-xs-2 text-left">[m
[32m+[m[32m                                            <h6><strong>{{delev.address}} </strong></h6>[m
[32m+[m[32m                                        </div>[m
[32m+[m[32m                                        <div class="col-12 col-sm-12 text-sm-center col-md-4 text-md-right row">[m
[32m+[m[32m                                                <h6><strong>{{delev.delivery_time}} jour</strong></h6>[m
[32m+[m[32m                                        </div>[m
[32m+[m[32m                                    </div>[m
[32m+[m[32m                            </div>[m
[32m+[m[32m                        </li>[m
[32m+[m[32m                    </ul>[m
                 </div>[m
[31m-                <div class="col-12 col-sm-12 text-sm-center col-md-4 text-md-right row">[m
[31m-                    <div class="col-3 col-sm-3 col-md-6 text-md-right" style="padding-top: 5px">[m
[31m-                        <h6><strong>{{delev.price}} €</strong></h6>[m
[32m+[m[32m            </div>[m
[32m+[m[32m        </div>[m
[32m+[m[32m    </div>[m
[32m+[m[32m</div>[m
[32m+[m[32m<!--payment form -->[m
[32m+[m[32m<div class="container">[m
[32m+[m[32m    <div class="page-header">[m
[32m+[m[32m        <h1 class="text-center">Paiement  <small>par carte de crédit</small></h1>[m
[32m+[m[32m    </div>[m
[32m+[m[32m    <!-- Credit Card Payment Form - START -->[m
[32m+[m[32m    <div class="container">[m
[32m+[m[32m        <div class="row">[m
[32m+[m[32m            <div class="col-xs-12 col-md-4 col-md-offset-4">[m
[32m+[m[32m                <div class="panel panel-default">[m
[32m+[m[32m                    <div class="panel-heading">[m
[32m+[m[32m                        <div class="row">[m
[32m+[m[32m                            <h3 class="text-center">Paiement</h3>[m
[32m+[m[32m                            <img class="img-responsive cc-img" src="assets/images/creditcardicons.png">[m
[32m+[m[32m                        </div>[m
                     </div>[m
[31m-                </div>[m
[31m-                <div class="col-12 col-sm-12 text-sm-center col-md-4 text-md-right row">[m
[31m-                    <div class="col-3 col-sm-3 col-md-6 text-md-right" style="padding-top: 5px">[m
[31m-                        <h6><strong>{{delev.delivery_time}} jour</strong></h6>[m
[32m+[m[32m                    <div class="panel-body">[m
[32m+[m[32m                        <form role="form">[m
[32m+[m[32m                            <div class="row">[m
[32m+[m[32m                                <div class="col-xs-12">[m
[32m+[m[32m                                    <div class="form-group">[m
[32m+[m[32m                                        <label>NUMÉRO DE CARTE</label>[m
[32m+[m[32m                                        <div class="input-group">[m
[32m+[m[32m                                            <input type="tel" class="form-control" placeholder="NUMÉRO DE CARTE" />[m
[32m+[m[32m                                            <span class="input-group-addon"><span class="fa fa-credit-card"></span></span>[m
[32m+[m[32m                                        </div>[m
[32m+[m[32m                                    </div>[m
[32m+[m[32m                                </div>[m
[32m+[m[32m                            </div>[m
[32m+[m[32m                            <div class="row">[m
[32m+[m[32m                                <div class="col-xs-7 col-md-7">[m
[32m+[m[32m                                    <div class="form-group">[m
[32m+[m[32m                                        <label><span class="hidden-xs">DATE D'EXPIRATION</span> </label>[m
[32m+[m[32m                                        <input type="tel" class="form-control" placeholder="MM / YY" />[m
[32m+[m[32m                                    </div>[m
[32m+[m[32m                                </div>[m
[32m+[m[32m                                <div class="col-xs-5 col-md-5 pull-right">[m
[32m+[m[32m                                    <div class="form-group">[m
[32m+[m[32m                                        <label>CV CODE</label>[m
[32m+[m[32m                                        <input type="tel" class="form-control" placeholder="CVC" />[m
[32m+[m[32m                                    </div>[m
[32m+[m[32m                                </div>[m
[32m+[m[32m                            </div>[m
[32m+[m[32m                            <div class="row">[m
[32m+[m[32m                                <div class="col-xs-12">[m
[32m+[m[32m                                    <div class="form-group">[m
[32m+[m[32m                                        <label>PROPRIÉTAIRE DE LA CARTE</label>[m
[32m+[m[32m                                        <input type="text" class="form-control" placeholder="PROPRIÉTAIRE DE LA CARTE" />[m
[32m+[m[32m                                    </div>[m
[32m+[m[32m                                </div>[m
[32m+[m[32m                            </div>[m
[32m+[m[32m                        </form>[m
[32m+[m[32m                    </div>[m
[32m+[m[32m                    <div class="panel-footer">[m
[32m+[m[32m                        <div class="row">[m
[32m+[m[32m                            <div class="col-xs-12">[m
[32m+[m[32m                                <button class="btn  btn-lg btn-block payment-btn" routerLink="/confirmation" >PAYER</button>[m
[32m+[m[32m                            </div>[m
[32m+[m[32m                        </div>[m
                     </div>[m
                 </div>[m
[31m-[m
[31m-[m
[32m+[m[32m            </div>[m
         </div>[m
[31m-                <hr>[m
[31m-            </form>[m
     </div>[m
[31m-[m
[31m-</div>[m
[31m-[m
[32m+[m[32m    <!-- Credit Card Payment Form - END -->[m
 </div>[m
[31m-[m
[31m-<!--payment form -->[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-<a routerLink="/confirmation">payer</a>[m
\ No newline at end of file[m
[1mdiff --git a/src/app/payment/payment.component.scss b/src/app/payment/payment.component.scss[m
[1mindex e536693..f76898e 100644[m
[1m--- a/src/app/payment/payment.component.scss[m
[1m+++ b/src/app/payment/payment.component.scss[m
[36m@@ -23,6 +23,52 @@[m
 .pink{[m
   color: #F71073;[m
 }[m
[31m-[m
[32m+[m[32m.list-group-item{[m
[32m+[m[32m  border: 0;[m
[32m+[m[32m  padding-top: 15px;[m
[32m+[m[32m  border-top: 1px solid;[m
[32m+[m[32m  border-color: rgba(37,40,43,0.1);[m
[32m+[m[32m}[m
[32m+[m[32m.list-group .list-group-item:first-child{[m
[32m+[m[32m  border:0;[m
[32m+[m[32m}[m
[32m+[m[32m.list-group .list-group-item a{[m
[32m+[m[32m  color: #2895F1;[m
[32m+[m[32m  cursor: pointer;[m
[32m+[m[32m  text-decoration: none;[m
[32m+[m[32m}[m
[32m+[m[32m.list-group.list-group-header{[m
[32m+[m[32m  padding:0;[m
[32m+[m[32m  margin:0;[m
[32m+[m[32m}[m
[32m+[m[32m.list-group.list-group-body .glyphicon {[m
[32m+[m[32m  font-size: 25px;[m
[32m+[m[32m  vertical-align: middle;[m
[32m+[m[32m}[m
[32m+[m[32m.list-group-panel{[m
[32m+[m[32m  border: 1px solid #ccdbeb;[m
[32m+[m[32m  border-radius: 0;[m
[32m+[m[32m}[m
 /*payment*/[m
[32m+[m[32m.payment-btn:hover {[m
[32m+[m[32m  box-shadow: 0 12px 16px 0 rgba(0,0,0,0.24), 0 17px 50px 0 rgba(0,0,0,0.19);[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.payment-btn{[m
[32m+[m[32m  border: none;[m
[32m+[m[32m  padding: 0.8em 2.5em;[m
[32m+[m[32m  font-size: 15px;[m
[32m+[m[32m  outline: none;[m
[32m+[m[32m  text-transform: uppercase;[m
[32m+[m[32m  font-weight: 700;[m
[32m+[m[32m  letter-spacing: 1px;[m
[32m+[m[32m  background: #2fdab8;[m
[32m+[m[32m  color: #fff;[m
[32m+[m[32m  margin-top: 2px;[m
[32m+[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.cc-img {[m
[32m+[m[32m   margin: 0 auto;[m
[32m+[m[32m }[m
 [m
[1mdiff --git a/src/assets/images/creditcardicons.png b/src/assets/images/creditcardicons.png[m
[1mnew file mode 100644[m
[1mindex 0000000..a8d386f[m
Binary files /dev/null and b/src/assets/images/creditcardicons.png differ

[33mcommit 013390f7b405fa84c3172e534abca6b647886113[m
Author: Nouha <nouha.bensalem1992@gmail.com>
Date:   Mon May 21 16:54:52 2018 +0100

    fix the order style

[1mdiff --git a/package-lock.json b/package-lock.json[m
[1mindex acce101..776acc7 100644[m
[1m--- a/package-lock.json[m
[1m+++ b/package-lock.json[m
[36m@@ -1188,7 +1188,7 @@[m
       "integrity": "sha1-OciRjO/1eZ+D+UkqhI9iWt0Mdm8=",[m
       "dev": true,[m
       "requires": {[m
[31m-        "hoek": "4.2.1"[m
[32m+[m[32m        "hoek": "2.16.3"[m
       }[m
     },[m
     "bootstrap": {[m
[1mdiff --git a/src/app/orders/orders.component.html b/src/app/orders/orders.component.html[m
[1mindex ccbe439..0824556 100644[m
[1m--- a/src/app/orders/orders.component.html[m
[1m+++ b/src/app/orders/orders.component.html[m
[36m@@ -1,7 +1,35 @@[m
[31m-<div class="container" style="margin-top: 50px;" >[m
[31m-  <div *ngFor="let order of orders; let i = index;" >[m
[31m-    {{order.id}}[m
[31m-      {{order.amount}}[m
[31m-      <button (click)="onDelete(order.id)">annuler commande </button>[m
[32m+[m[32m<div class="container-fluid" style="margin-top: 50px;" >[m
[32m+[m[32m  <h4 class="white-w3ls">Mes   <span>commandes</span></h4>[m
[32m+[m[32m  <hr>[m
[32m+[m[32m  <div class="row">[m
[32m+[m[32m    <div class="col-xs-12" style="">[m
[32m+[m[32m      <div class="panel panel-default list-group-panel">[m
[32m+[m[32m        <div class="panel-body">[m
[32m+[m[32m          <ul class="list-group list-group-header">[m
[32m+[m[32m            <li class="list-group-item list-group-body">[m
[32m+[m[32m              <div class="row">[m
[32m+[m[32m                <div class="col-xs-3 text-left" style="color: #2fdab8"><b>Etat</b></div>[m
[32m+[m[32m                <div class="col-xs-2" style="color: #2fdab8"><b>Date commande</b></div>[m
[32m+[m[32m                <div class="col-xs-2" style="color: #2fdab8"><b>Montant</b></div>[m
[32m+[m[32m                <div class="col-xs-2" style="color: #2fdab8"><b>Date livraison</b></div>[m
[32m+[m[32m              </div>[m
[32m+[m[32m            </li>[m
[32m+[m[32m          </ul>[m
[32m+[m[32m          <ul class="list-group list-group-body" style="">[m
[32m+[m[32m            <li class="list-group-item">[m
[32m+[m[32m              <div class="row">[m
[32m+[m[32m                <div *ngFor="let order of orders; let i = index;" >[m
[32m+[m[32m                <div class="col-xs-3 text-left" style=" ">{{order.status}}</div>[m
[32m+[m[32m                <div class="col-xs-2" style="">{{order.order_date}}</div>[m
[32m+[m[32m                <div class="col-xs-2" style="">{{order.amount}} €</div>[m
[32m+[m[32m                <div class="col-xs-2" style="">{{order.delivery_date}}</div>[m
[32m+[m[32m                <div class="col-xs-offset-10" style=""><button id="cancel-btn" (click)="onDelete(order.id)">annuler</button></div>[m
[32m+[m[32m                </div>[m
[32m+[m[32m                </div>[m
[32m+[m[32m            </li>[m
[32m+[m[32m          </ul>[m
[32m+[m[32m        </div>[m
[32m+[m[32m      </div>[m
[32m+[m[32m    </div>[m
   </div>[m
[31m-</div>[m
[32m+[m[32m</div>[m
\ No newline at end of file[m
[1mdiff --git a/src/app/orders/orders.component.scss b/src/app/orders/orders.component.scss[m
[1mindex e69de29..10a9534 100644[m
[1m--- a/src/app/orders/orders.component.scss[m
[1m+++ b/src/app/orders/orders.component.scss[m
[36m@@ -0,0 +1,43 @@[m
[32m+[m[32m#cancel-btn:hover {[m
[32m+[m[32m  box-shadow: 0 12px 16px 0 rgba(0,0,0,0.24), 0 17px 50px 0 rgba(0,0,0,0.19);[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m#cancel-btn{[m
[32m+[m[32m  border: none;[m
[32m+[m[32m  padding: 0.8em 2.5em;[m
[32m+[m[32m  font-size: 10px;[m
[32m+[m[32m  outline: none;[m
[32m+[m[32m  text-transform: uppercase;[m
[32m+[m[32m  font-weight: 700;[m
[32m+[m[32m  letter-spacing: 1px;[m
[32m+[m[32m  background: #2fdab8;[m
[32m+[m[32m  color: #fff;[m
[32m+[m[32m  margin-top: 2px;[m
[32m+[m
[32m+[m[32m}[m
[32m+[m[32m.list-group-item{[m
[32m+[m[32m  border: 0;[m
[32m+[m[32m  padding-top: 15px;[m
[32m+[m[32m  border-top: 1px solid;[m
[32m+[m[32m  border-color: rgba(37,40,43,0.1);[m
[32m+[m[32m}[m
[32m+[m[32m.list-group .list-group-item:first-child{[m
[32m+[m[32m  border:0;[m
[32m+[m[32m}[m
[32m+[m[32m.list-group .list-group-item a{[m
[32m+[m[32m  color: #2895F1;[m
[32m+[m[32m  cursor: pointer;[m
[32m+[m[32m  text-decoration: none;[m
[32m+[m[32m}[m
[32m+[m[32m.list-group.list-group-header{[m
[32m+[m[32m  padding:0;[m
[32m+[m[32m  margin:0;[m
[32m+[m[32m}[m
[32m+[m[32m.list-group.list-group-body .glyphicon {[m
[32m+[m[32m  font-size: 25px;[m
[32m+[m[32m  vertical-align: middle;[m
[32m+[m[32m}[m
[32m+[m[32m.list-group-panel{[m
[32m+[m[32m  border: 1px solid #ccdbeb;[m
[32m+[m[32m  border-radius: 0;[m
[32m+[m[32m}[m
\ No newline at end of file[m

[33mcommit 0fe45ec800e52f5555d8313f208bb988843b3289[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Mon May 21 12:08:47 2018 +0100

    enable the promotion in product component

[1mdiff --git a/src/app/product/product.component.html b/src/app/product/product.component.html[m
[1mindex da9bad2..d0cb89c 100644[m
[1m--- a/src/app/product/product.component.html[m
[1m+++ b/src/app/product/product.component.html[m
[36m@@ -8,18 +8,17 @@[m
                     <a [routerLink]="[id]" class="link-product-add-cart">Afficher</a>[m
                 </div>[m
             </div>[m
[31m-<!--[m
[31m-            <span class="product-new-top" *ngIf="promotions.length>0">-{{promotions[0].discount}}%</span>[m
[31m--->[m
[32m+[m
[32m+[m[32m            <span class="product-new-top" *ngIf="promotions.length>0 && promotions[0].deleted==false">-{{promotions[0].discount}}%</span>[m
 [m
         </div>[m
         <div class="item-info-product ">[m
             <h4><a [routerLink]="[id]">{{productName}}</a></h4>[m
[31m-          <!--  <div class="info-product-price" *ngIf="promotions.length>0">[m
[32m+[m[32m            <div class="info-product-price" *ngIf="promotions.length>0 && promotions[0].deleted==false">[m
                 <span class="item_price">{{price-(price*promotions[0].discount/100)}} €</span>[m
                 <del>{{price}} €</del>[m
[31m-            </div>-->[m
[31m-            <div class="info-product-price" >[m
[32m+[m[32m            </div>[m
[32m+[m[32m            <div class="info-product-price" *ngIf="promotions.length==0 || promotions[0].deleted==true">[m
                 <span class="item_price">{{price}} €</span>[m
             </div>[m
 [m
[36m@@ -34,8 +33,8 @@[m
 -->[m
             <div class="snipcart-details top_brand_home_details item_add single-item hvr-outline-out button2">[m
 [m
[31m-            <input type="submit" name="submit" value="Ajouter au panier" class="button" *ngIf="!selected" (click)="onAdd(id,price,productName,url+images[0].name)">[m
[31m-[m
[32m+[m[32m            <input type="submit" name="submit" value="Ajouter au panier" class="button" *ngIf="!selected &&(promotions.length==0||promotions[0].deleted==true)" (click)="onAdd(id,price,productName,url+images[0].name)">[m
[32m+[m[32m                <input type="submit" name="submit" value="Ajouter au panier" class="button" *ngIf="!selected &&promotions.length>0 &&promotions[0].deleted==false" (click)="onAdd(id,(price-(price*promotions[0].discount/100)),productName,url+images[0].name)">[m
             <input type="submit" name="delete" value="Supprimer" class="button" (click)="onDelete(id,price)" *ngIf="selected">[m
 [m
             </div>[m
[1mdiff --git a/src/app/top-nav/top-nav.component.html b/src/app/top-nav/top-nav.component.html[m
[1mindex c234900..39d9647 100644[m
[1m--- a/src/app/top-nav/top-nav.component.html[m
[1m+++ b/src/app/top-nav/top-nav.component.html[m
[36m@@ -4,7 +4,7 @@[m
             <li> <a routerLink="auth"  *ngIf="!isAuth"><i class="fa fa-unlock-alt" aria-hidden="true"></i> Se connecter </a></li>[m
             <li> <a routerLink="signup" *ngIf="!isAuth" ><i class="fa fa-pencil-square-o" aria-hidden="true"></i> S'inscrire </a></li>[m
             <li><i class="fa fa-phone" aria-hidden="true"></i> Appel : +555 558 7885</li>[m
[31m-            <li><i class="fa fa-envelope-o" aria-hidden="true"></i> <a href="#">sbzMarket@contact.com</a></li>[m
[32m+[m[32m            <li><i class="fa fa-envelope-o" aria-hidden="true"></i> <a >contact@sbzmarket.com</a></li>[m
         </ul>[m
     </div>[m
 </div>[m

[33mcommit d9e279ef29843a1d0aa041ba5541ac4d6c290881[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Mon May 21 09:59:24 2018 +0100

    update product_list

[1mdiff --git a/src/app/product-list/product-list.component.html b/src/app/product-list/product-list.component.html[m
[1mindex aa58ab5..560a646 100644[m
[1m--- a/src/app/product-list/product-list.component.html[m
[1m+++ b/src/app/product-list/product-list.component.html[m
[36m@@ -39,13 +39,13 @@[m
             <span *ngIf="!idc;">[m
                 <app-product *ngFor="let product of category.products; let i = index;" [productName]="product.product_name"[m
                              [id]="product.id" [price]="product.price" [quantity]="product.quantity" [images]="product.images"[m
[31m-                             [deleted]="product.deleted" [sizes]="product.sizes">[m
[32m+[m[32m                             [deleted]="product.deleted" [sizes]="product.sizes" [promotions]="product.promotions">[m
                 </app-product>[m
             </span>[m
             <span *ngIf="category.id === idc">[m
                 <app-product *ngFor="let product of category.products; let i = index;" [productName]="product.product_name"[m
                              [id]="product.id" [price]="product.price" [quantity]="product.quantity" [images]="product.images"[m
[31m-                             [deleted]="product.deleted" [sizes]="product.sizes">[m
[32m+[m[32m                             [deleted]="product.deleted" [sizes]="product.sizes" [promotions]="product.promotions">[m
                 </app-product>[m
             </span>[m
         </span>[m
[1mdiff --git a/src/app/product/product.component.html b/src/app/product/product.component.html[m
[1mindex 7da546c..da9bad2 100644[m
[1m--- a/src/app/product/product.component.html[m
[1m+++ b/src/app/product/product.component.html[m
[36m@@ -8,14 +8,19 @@[m
                     <a [routerLink]="[id]" class="link-product-add-cart">Afficher</a>[m
                 </div>[m
             </div>[m
[31m-            <span class="product-new-top">-20%</span>[m
[32m+[m[32m<!--[m
[32m+[m[32m            <span class="product-new-top" *ngIf="promotions.length>0">-{{promotions[0].discount}}%</span>[m
[32m+[m[32m-->[m
 [m
         </div>[m
         <div class="item-info-product ">[m
             <h4><a [routerLink]="[id]">{{productName}}</a></h4>[m
[31m-            <div class="info-product-price">[m
[31m-                <span class="item_price">{{price}} €</span>[m
[32m+[m[32m          <!--  <div class="info-product-price" *ngIf="promotions.length>0">[m
[32m+[m[32m                <span class="item_price">{{price-(price*promotions[0].discount/100)}} €</span>[m
                 <del>{{price}} €</del>[m
[32m+[m[32m            </div>-->[m
[32m+[m[32m            <div class="info-product-price" >[m
[32m+[m[32m                <span class="item_price">{{price}} €</span>[m
             </div>[m
 [m
            <!-- <form [formGroup]="itemForm" (ngSubmit)="onAdd(id,price,productName,url+images[0].name)" *ngIf="sizes.length>0">-->[m
[1mdiff --git a/src/app/product/product.component.ts b/src/app/product/product.component.ts[m
[1mindex 8b193d8..3a24020 100644[m
[1m--- a/src/app/product/product.component.ts[m
[1m+++ b/src/app/product/product.component.ts[m
[36m@@ -8,6 +8,7 @@[m [mimport {Subscription} from 'rxjs/Subscription';[m
 import {Subject} from 'rxjs/Subject';[m
 import {forEach} from '@angular/router/src/utils/collection';[m
 import {FormBuilder, FormGroup, Validators} from '@angular/forms';[m
[32m+[m[32mimport {DATE} from 'ngx-bootstrap/chronos/units/constants';[m
 [m
 @Component({[m
     providers: [TopNavComponent ],[m
[36m@@ -17,6 +18,7 @@[m [mimport {FormBuilder, FormGroup, Validators} from '@angular/forms';[m
 })[m
 export class ProductComponent implements OnInit {[m
     products = [] ;[m
[32m+[m[32m    date: Date;[m
     @Input() id: number;[m
     @Input() deleted: boolean;[m
     @Input()  productName: string ;[m
[36m@@ -25,6 +27,7 @@[m [mexport class ProductComponent implements OnInit {[m
     @Input() quantity: number ;[m
     @Input() images = [];[m
     @Input() sizes = [];[m
[32m+[m[32m    @Input() promotions = [];[m
     public subscription: Subscription;[m
     private val: Subject <any>;[m
     basket ;[m
[36m@@ -35,6 +38,7 @@[m [mexport class ProductComponent implements OnInit {[m
       this.basket = this.shoping.getProducts();[m
   }[m
   ngOnInit() {[m
[32m+[m[32m      this.date = new Date();[m
       for (const b of this.basket) {[m
           if (this.id === b.id) {[m
               this.selected = true;[m

[33mcommit 6503356691bbce5ff922106a0445dce9f7906d4f[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Wed May 16 12:25:36 2018 +0100

    update product component

[1mdiff --git a/src/app/app.module.ts b/src/app/app.module.ts[m
[1mindex f5d2fbe..4a9a052 100644[m
[1m--- a/src/app/app.module.ts[m
[1m+++ b/src/app/app.module.ts[m
[36m@@ -38,6 +38,7 @@[m [mimport { ConfirmationComponent } from './confirmation/confirmation.component';[m
 import { LoadingComponent } from './loading/loading.component';[m
 import { ModalModule } from 'ngx-bootstrap/modal';[m
 import { OrdersComponent } from './orders/orders.component';[m
[32m+[m[32mimport { OrderItemsComponent } from './order-items/order-items.component';[m
 [m
 [m
 const appRoutes: Routes = [[m
[36m@@ -114,6 +115,7 @@[m [mconst appRoutes: Routes = [[m
     ConfirmationComponent,[m
     LoadingComponent,[m
     OrdersComponent,[m
[32m+[m[32m    OrderItemsComponent,[m
   ],[m
   imports: [[m
     BrowserModule,[m
[1mdiff --git a/src/app/order-items/order-items.component.html b/src/app/order-items/order-items.component.html[m
[1mnew file mode 100644[m
[1mindex 0000000..e69de29[m
[1mdiff --git a/src/app/order-items/order-items.component.scss b/src/app/order-items/order-items.component.scss[m
[1mnew file mode 100644[m
[1mindex 0000000..e69de29[m
[1mdiff --git a/src/app/order-items/order-items.component.ts b/src/app/order-items/order-items.component.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..d3724ec[m
[1m--- /dev/null[m
[1m+++ b/src/app/order-items/order-items.component.ts[m
[36m@@ -0,0 +1,17 @@[m
[32m+[m[32mimport {Component, Input, OnInit} from '@angular/core';[m
[32m+[m
[32m+[m[32m@Component({[m
[32m+[m[32m  selector: 'app-order-items',[m
[32m+[m[32m  templateUrl: './order-items.component.html',[m
[32m+[m[32m  styleUrls: ['./order-items.component.scss'][m
[32m+[m[32m})[m
[32m+[m[32mexport class OrderItemsComponent implements OnInit {[m
[32m+[m[32m    @Input() id: number;[m
[32m+[m[32m    @Input() name: string;[m
[32m+[m[32m    @Input() quantity: string;[m
[32m+[m[32m  constructor() { }[m
[32m+[m
[32m+[m[32m  ngOnInit() {[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m}[m
[1mdiff --git a/src/app/payment/payment.component.html b/src/app/payment/payment.component.html[m
[1mindex f3fdd98..018200e 100644[m
[1m--- a/src/app/payment/payment.component.html[m
[1m+++ b/src/app/payment/payment.component.html[m
[36m@@ -42,12 +42,13 @@[m
 [m
             <div class="row" *ngFor="let delev of delivery; let i = index;">[m
 [m
[31m-                <div class="col-12 text-sm-center col-sm-12 text-md-left col-md-6"  style="margin-top: 10px;">[m
[31m-[m
[31m-                   <input type="radio" name="delivery" class="pink" (click)="onChecked(delev.id)">&nbsp;{{delev.name}}[m
[31m-[m
[32m+[m[32m                <div class="col-12 text-sm-center col-sm-12 text-md-left col-md-6"  style="margin-top: 10px;" *ngIf="i==0">[m
[32m+[m[32m                   <input type="radio" name="delivery" class="pink" (click)="onChecked(delev.id)" checked >&nbsp;{{delev.name}}[m
[32m+[m[32m                    <p >{{delev.address}}</p>[m
[32m+[m[32m                </div>[m
[32m+[m[32m                <div class="col-12 text-sm-center col-sm-12 text-md-left col-md-6"  style="margin-top: 10px;" *ngIf="i>0">[m
[32m+[m[32m                    <input type="radio" name="delivery" class="pink" (click)="onChecked(delev.id)"  >&nbsp;{{delev.name}}[m
                     <p >{{delev.address}}</p>[m
[31m-[m
                 </div>[m
                 <div class="col-12 col-sm-12 text-sm-center col-md-4 text-md-right row">[m
                     <div class="col-3 col-sm-3 col-md-6 text-md-right" style="padding-top: 5px">[m
[36m@@ -70,8 +71,7 @@[m
 [m
 </div>[m
 [m
[31m-[m
[31m-[m
[32m+[m[32m<!--payment form -->[m
 [m
 [m
 [m
[1mdiff --git a/src/app/payment/payment.component.scss b/src/app/payment/payment.component.scss[m
[1mindex 8ecb369..e536693 100644[m
[1m--- a/src/app/payment/payment.component.scss[m
[1m+++ b/src/app/payment/payment.component.scss[m
[36m@@ -24,4 +24,5 @@[m
   color: #F71073;[m
 }[m
 [m
[31m-/*delevry*/[m
[32m+[m[32m/*payment*/[m
[41m+[m
[1mdiff --git a/src/app/product/product.component.html b/src/app/product/product.component.html[m
[1mindex 3220e0e..7da546c 100644[m
[1m--- a/src/app/product/product.component.html[m
[1m+++ b/src/app/product/product.component.html[m
[36m@@ -18,23 +18,24 @@[m
                 <del>{{price}} €</del>[m
             </div>[m
 [m
[31m-            <form [formGroup]="itemForm" (ngSubmit)="onAdd(id,price,productName,url+images[0].name)">[m
[31m-                <div *ngIf="sizes.length>0" class="form-group">[m
[32m+[m[32m           <!-- <form [formGroup]="itemForm" (ngSubmit)="onAdd(id,price,productName,url+images[0].name)" *ngIf="sizes.length>0">-->[m
[32m+[m[32m              <!--  <div  class="form-group">[m
                         <select class="form-control"  formControlName="size">[m
                             <option value="{{size.size}}" *ngFor="let size of sizes; let i = index;" >[m
                                 {{size.size}}[m
                             </option>[m
                         </select>[m
                 </div>[m
[31m-[m
[32m+[m[32m-->[m
             <div class="snipcart-details top_brand_home_details item_add single-item hvr-outline-out button2">[m
 [m
[31m-            <input type="submit" name="submit" value="Ajouter au panier" class="button" *ngIf="!selected">[m
[32m+[m[32m            <input type="submit" name="submit" value="Ajouter au panier" class="button" *ngIf="!selected" (click)="onAdd(id,price,productName,url+images[0].name)">[m
 [m
[31m-            <input type="button" name="delete" value="Supprimer" class="button" (click)="onDelete(id,price)" *ngIf="selected">[m
[32m+[m[32m            <input type="submit" name="delete" value="Supprimer" class="button" (click)="onDelete(id,price)" *ngIf="selected">[m
 [m
             </div>[m
[31m-            </form>[m
[32m+[m[32m          <!--  </form>-->[m
[32m+[m
         </div>[m
     </div>[m
 </div>[m
[1mdiff --git a/src/app/product/product.component.ts b/src/app/product/product.component.ts[m
[1mindex 7fc1b6f..8b193d8 100644[m
[1m--- a/src/app/product/product.component.ts[m
[1m+++ b/src/app/product/product.component.ts[m
[36m@@ -40,12 +40,12 @@[m [mexport class ProductComponent implements OnInit {[m
               this.selected = true;[m
           }[m
       }[m
[31m-      this.initForm();[m
[32m+[m[32m    /*  this.initForm();*/[m
   }[m
   onAdd(id, price , name, image) {[m
[31m-      const formValue = this.itemForm.value;[m
[32m+[m[32m     /* const formValue = this.itemForm.value;*/[m
 [m
[31m-      this.shoping.AddToBasket(id, price , name, image, 1, formValue['size']);[m
[32m+[m[32m      this.shoping.AddToBasket(id, price , name, image, 1, 'xs');[m
       this.selected = true;[m
       this.basket = this.shoping.getProducts();[m
   }[m
[36m@@ -54,9 +54,10 @@[m [mexport class ProductComponent implements OnInit {[m
         this.selected = false;[m
         this.basket = this.shoping.getProducts();[m
     }[m
[31m-    initForm() {[m
[32m+[m[32m   /* initForm() {[m
[32m+[m[32m      const size = this.sizes[0].size;[m
         this.itemForm = this.formBuilder.group({[m
[31m-            size: [this.sizes[0].size, [Validators.required]][m
[32m+[m[32m            size: [size, [Validators.required]][m
         });[m
[31m-    }[m
[32m+[m[32m    }*/[m
 }[m

[33mcommit 4e7334a390dc351f16aa3c09d9c9e8ce84149adf[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Mon May 14 14:36:45 2018 +0100

    add the delivery module

[1mdiff --git a/src/app/basket-list/basket-list.component.html b/src/app/basket-list/basket-list.component.html[m
[1mindex 9a8d2d3..b11acc3 100644[m
[1m--- a/src/app/basket-list/basket-list.component.html[m
[1m+++ b/src/app/basket-list/basket-list.component.html[m
[36m@@ -1,6 +1,4 @@[m
[31m-<div class="container">[m
[31m-[m
[31m-[m
[32m+[m[32m<div class="container" >[m
     <div class="row bs-wizard" style="border-bottom:0;">[m
 [m
         <div class="col-xs-3 bs-wizard-step active">[m
[36m@@ -9,7 +7,6 @@[m
             <a  class="bs-wizard-dot"></a>[m
 [m
         </div>[m
[31m-[m
         <div class="col-xs-3 bs-wizard-step disabled"><!-- complete -->[m
             <div class="text-center bs-wizard-stepnum">Livraison</div>[m
             <div class="progress"><div class="progress-bar"></div></div>[m
[36m@@ -35,9 +32,10 @@[m
 [m
 <!--basket-->[m
 <div class="container" id="main">[m
[31m-    <h2 class="pink">Mon Panier</h2>[m
[32m+[m[32m    <h2 class="pink" *ngIf="total !=0">Mon Panier</h2>[m
[32m+[m[32m    <h4 class="pink" *ngIf="total ==0" align="center">Votre panier est vide pour le moment.</h4>[m
     <hr>[m
[31m-    <div class="card shopping-cart" >[m
[32m+[m[32m    <div class="card shopping-cart" *ngIf="total !=0">[m
 [m
         <div class="card-body">[m
             <!-- PRODUCT -->[m
[36m@@ -80,11 +78,8 @@[m
                             </div>[m
                             <h4 class="modal-title">Êtes-vous sûr ?</h4>[m
                         </div>[m
[31m-[m
[31m-[m
                             <button type="button" class="btn btn-info" aria-label="Close" (click)="modalRef.hide()"><span class="fa fa-close" > </span> Quitter</button>[m
                             <button class="btn btn-success" type="submit" (click)="onDelete(product.id, product.price)"><span class="fa fa-check-circle"> </span> Confirmer</button>[m
[31m-[m
                     </div>[m
                 </ng-template>[m
 [m
[36m@@ -95,6 +90,7 @@[m
 [m
 [m
         </div>[m
[32m+[m
         <div class="card-footer">[m
 [m
             <div class="pull-right" style="margin: 10px">[m
[1mdiff --git a/src/app/models/Order.model.ts b/src/app/models/Order.model.ts[m
[1mindex b36d58d..f484087 100644[m
[1m--- a/src/app/models/Order.model.ts[m
[1m+++ b/src/app/models/Order.model.ts[m
[36m@@ -3,6 +3,6 @@[m [mimport {Item} from './Item.model';[m
 export class Order {[m
     constructor([m
         public amount: number,[m
[31m-        public items: Item [][m
[32m+[m[32m        public items: Item [],[m
     ) {}[m
 }[m
[1mdiff --git a/src/app/payment/payment.component.html b/src/app/payment/payment.component.html[m
[1mindex 4fd55e6..f3fdd98 100644[m
[1m--- a/src/app/payment/payment.component.html[m
[1m+++ b/src/app/payment/payment.component.html[m
[36m@@ -31,6 +31,44 @@[m
 [m
 [m
 [m
[32m+[m[32m<div class="container" id="main">[m
[32m+[m[32m    <h2 class="pink">Livreurs</h2>[m
[32m+[m[32m    <hr>[m
[32m+[m[32m    <div class="card shopping-cart">[m
[32m+[m
[32m+[m[32m        <div class="card-body" >[m
[32m+[m[32m            <form action="">[m
[32m+[m
[32m+[m
[32m+[m[32m            <div class="row" *ngFor="let delev of delivery; let i = index;">[m
[32m+[m
[32m+[m[32m                <div class="col-12 text-sm-center col-sm-12 text-md-left col-md-6"  style="margin-top: 10px;">[m
[32m+[m
[32m+[m[32m                   <input type="radio" name="delivery" class="pink" (click)="onChecked(delev.id)">&nbsp;{{delev.name}}[m
[32m+[m
[32m+[m[32m                    <p >{{delev.address}}</p>[m
[32m+[m
[32m+[m[32m                </div>[m
[32m+[m[32m                <div class="col-12 col-sm-12 text-sm-center col-md-4 text-md-right row">[m
[32m+[m[32m                    <div class="col-3 col-sm-3 col-md-6 text-md-right" style="padding-top: 5px">[m
[32m+[m[32m                        <h6><strong>{{delev.price}} €</strong></h6>[m
[32m+[m[32m                    </div>[m
[32m+[m[32m                </div>[m
[32m+[m[32m                <div class="col-12 col-sm-12 text-sm-center col-md-4 text-md-right row">[m
[32m+[m[32m                    <div class="col-3 col-sm-3 col-md-6 text-md-right" style="padding-top: 5px">[m
[32m+[m[32m                        <h6><strong>{{delev.delivery_time}} jour</strong></h6>[m
[32m+[m[32m                    </div>[m
[32m+[m[32m                </div>[m
[32m+[m
[32m+[m
[32m+[m[32m        </div>[m
[32m+[m[32m                <hr>[m
[32m+[m[32m            </form>[m
[32m+[m[32m    </div>[m
[32m+[m
[32m+[m[32m</div>[m
[32m+[m
[32m+[m[32m</div>[m
 [m
 [m
 [m
[1mdiff --git a/src/app/payment/payment.component.scss b/src/app/payment/payment.component.scss[m
[1mindex 9b150dd..8ecb369 100644[m
[1m--- a/src/app/payment/payment.component.scss[m
[1m+++ b/src/app/payment/payment.component.scss[m
[36m@@ -19,4 +19,9 @@[m
 .bs-wizard > .bs-wizard-step.disabled > .bs-wizard-dot:after {opacity: 0;}[m
 .bs-wizard > .bs-wizard-step:first-child  > .progress {left: 50%; width: 50%;}[m
 .bs-wizard > .bs-wizard-step:last-child  > .progress {width: 50%;}[m
[31m-.bs-wizard > .bs-wizard-step.disabled a.bs-wizard-dot{ pointer-events: none; }[m
\ No newline at end of file[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.disabled a.bs-wizard-dot{ pointer-events: none; }[m
[32m+[m[32m.pink{[m
[32m+[m[32m  color: #F71073;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m/*delevry*/[m
[1mdiff --git a/src/app/payment/payment.component.ts b/src/app/payment/payment.component.ts[m
[1mindex dd744e6..a89d44b 100644[m
[1m--- a/src/app/payment/payment.component.ts[m
[1m+++ b/src/app/payment/payment.component.ts[m
[36m@@ -1,4 +1,6 @@[m
 import { Component, OnInit } from '@angular/core';[m
[32m+[m[32mimport {Subscription} from 'rxjs/Subscription';[m
[32m+[m[32mimport {ShopingService} from '../services/shoping.service';[m
 [m
 @Component({[m
   selector: 'app-payment',[m
[36m@@ -6,10 +8,21 @@[m [mimport { Component, OnInit } from '@angular/core';[m
   styleUrls: ['./payment.component.scss'][m
 })[m
 export class PaymentComponent implements OnInit {[m
[32m+[m[32m    delivery: any[];[m
[32m+[m[32m    deliverySubscription: Subscription;[m
[32m+[m[32m    constructor(private shopingService: ShopingService) { }[m
 [m
[31m-  constructor() { }[m
[31m-[m
[31m-  ngOnInit() {[m
[31m-  }[m
[31m-[m
[32m+[m[32m    ngOnInit() {[m
[32m+[m[32m        this.deliverySubscription = this.shopingService.deliverySubject.subscribe([m
[32m+[m[32m            (delivery: any[]) => {[m
[32m+[m[32m                this.delivery = delivery;[m
[32m+[m[32m            }[m
[32m+[m[32m        );[m
[32m+[m[32m        this.shopingService.emitDelivrySubject();[m
[32m+[m[32m        this.shopingService.getDeliveries();[m
[32m+[m[32m    }[m
[32m+[m[32m    onChecked(id) {[m
[32m+[m[32m        localStorage.removeItem('delivery');[m
[32m+[m[32m        localStorage.setItem('delivery', id);[m
[32m+[m[32m    }[m
 }[m
[1mdiff --git a/src/app/product/product.component.html b/src/app/product/product.component.html[m
[1mindex b0c7f83..3220e0e 100644[m
[1m--- a/src/app/product/product.component.html[m
[1m+++ b/src/app/product/product.component.html[m
[36m@@ -18,25 +18,23 @@[m
                 <del>{{price}} €</del>[m
             </div>[m
 [m
[31m-[m
[31m-            <!--<span *ngIf="sizes.length>0">[m
[31m-                    <p >Taille :</p>[m
[31m-                    <select  >[m
[31m-                        <option value="{{size.size}}" *ngFor="let size of sizes; let i = index;">[m
[31m-                            {{size.size}}[m
[31m-                        </option>[m
[31m-                    </select>[m
[31m-                </span>-->[m
[31m-[m
[31m-[m
[32m+[m[32m            <form [formGroup]="itemForm" (ngSubmit)="onAdd(id,price,productName,url+images[0].name)">[m
[32m+[m[32m                <div *ngIf="sizes.length>0" class="form-group">[m
[32m+[m[32m                        <select class="form-control"  formControlName="size">[m
[32m+[m[32m                            <option value="{{size.size}}" *ngFor="let size of sizes; let i = index;" >[m
[32m+[m[32m                                {{size.size}}[m
[32m+[m[32m                            </option>[m
[32m+[m[32m                        </select>[m
[32m+[m[32m                </div>[m
 [m
             <div class="snipcart-details top_brand_home_details item_add single-item hvr-outline-out button2">[m
 [m
[31m-            <input type="submit" name="submit" value="Ajouter au panier" class="button" (click)="onAdd(id,price,productName,url+images[0].name)" *ngIf="!selected">[m
[32m+[m[32m            <input type="submit" name="submit" value="Ajouter au panier" class="button" *ngIf="!selected">[m
 [m
[31m-            <input type="submit" name="submit" value="Supprimer" class="button" (click)="onDelete(id,price)" *ngIf="selected">[m
[32m+[m[32m            <input type="button" name="delete" value="Supprimer" class="button" (click)="onDelete(id,price)" *ngIf="selected">[m
 [m
             </div>[m
[32m+[m[32m            </form>[m
         </div>[m
     </div>[m
 </div>[m
[1mdiff --git a/src/app/product/product.component.ts b/src/app/product/product.component.ts[m
[1mindex 9575bc3..7fc1b6f 100644[m
[1m--- a/src/app/product/product.component.ts[m
[1m+++ b/src/app/product/product.component.ts[m
[36m@@ -40,9 +40,12 @@[m [mexport class ProductComponent implements OnInit {[m
               this.selected = true;[m
           }[m
       }[m
[32m+[m[32m      this.initForm();[m
   }[m
   onAdd(id, price , name, image) {[m
[31m-      this.shoping.AddToBasket(id, price , name, image, 1,  '');[m
[32m+[m[32m      const formValue = this.itemForm.value;[m
[32m+[m
[32m+[m[32m      this.shoping.AddToBasket(id, price , name, image, 1, formValue['size']);[m
       this.selected = true;[m
       this.basket = this.shoping.getProducts();[m
   }[m
[36m@@ -53,8 +56,7 @@[m [mexport class ProductComponent implements OnInit {[m
     }[m
     initForm() {[m
         this.itemForm = this.formBuilder.group({[m
[31m-            quantity: ['1', [Validators.required]],[m
[31m-            size: [ [Validators.required]][m
[32m+[m[32m            size: [this.sizes[0].size, [Validators.required]][m
         });[m
     }[m
 }[m
[1mdiff --git a/src/app/services/delivry.service.ts b/src/app/services/delivry.service.ts[m
[1mdeleted file mode 100644[m
[1mindex 696acc1..0000000[m
[1m--- a/src/app/services/delivry.service.ts[m
[1m+++ /dev/null[m
[36m@@ -1,8 +0,0 @@[m
[31m-import { Injectable } from '@angular/core';[m
[31m-[m
[31m-@Injectable()[m
[31m-export class DelivryService {[m
[31m-[m
[31m-  constructor() { }[m
[31m-[m
[31m-}[m
[1mdiff --git a/src/app/services/shoping.service.ts b/src/app/services/shoping.service.ts[m
[1mindex e9a2add..9f62c3f 100644[m
[1m--- a/src/app/services/shoping.service.ts[m
[1m+++ b/src/app/services/shoping.service.ts[m
[36m@@ -12,16 +12,30 @@[m [mexport class ShopingService {[m
     itemCount$ = this.itemCountSource.asObservable();[m
     totalPrice: number;[m
     orders = [];[m
[32m+[m[32m    delivery = [];[m
     orderSubject = new Subject<any[]>();[m
[32m+[m[32m    deliverySubject = new Subject<any[]>();[m
     private products = [];[m
     constructor(private httpClient: HttpClient) {[m
         this.itemCount = 0;[m
         this.itemCountSource.next(0);[m
         this.totalPrice = 0.0;[m
     }[m
[32m+[m[32m    public emitDelivrySubject() {[m
[32m+[m[32m        this.deliverySubject.next(this.delivery.slice());[m
[32m+[m[32m    }[m
[32m+[m[32m    public getDeliveries() {[m
[32m+[m[32m        this.httpClient.get<any[]>('http://localhost:8888/pfe_marketplace/web/app_dev.php/api/delivery').subscribe([m
[32m+[m[32m            (response) => {this.delivery = response;[m
[32m+[m[32m                this.emitDelivrySubject();[m
[32m+[m[32m            },[m
[32m+[m[32m            (error) => {console.log('Erreur ! :' + error); }[m
[32m+[m[32m        );[m
[32m+[m[32m    }[m
     saveToServer(body: any) {[m
         const customerId = localStorage.getItem('id');[m
[31m-        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/orders/' + customerId;[m
[32m+[m[32m        const deliveryId = localStorage.getItem('delivery');[m
[32m+[m[32m        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/orders/' + customerId + '/' + deliveryId;[m
         const b = JSON.stringify(body);[m
         this.httpClient.post(url, b, {[m
             headers: {'Content-Type': 'application/json'}[m

[33mcommit 0fdabe3bfdb3205a6ff204440fcbfe21f1a86970[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Mon May 14 09:58:20 2018 +0100

    update hoek in look.json

[1mdiff --git a/package-lock.json b/package-lock.json[m
[1mindex 776acc7..acce101 100644[m
[1m--- a/package-lock.json[m
[1m+++ b/package-lock.json[m
[36m@@ -1188,7 +1188,7 @@[m
       "integrity": "sha1-OciRjO/1eZ+D+UkqhI9iWt0Mdm8=",[m
       "dev": true,[m
       "requires": {[m
[31m-        "hoek": "2.16.3"[m
[32m+[m[32m        "hoek": "4.2.1"[m
       }[m
     },[m
     "bootstrap": {[m

[33mcommit 568340f773caf34bc8a1d1ccdc1e98bf9bce2601[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Mon May 14 09:52:38 2018 +0100

    update delevry service

[1mdiff --git a/package-lock.json b/package-lock.json[m
[1mindex 26e90e7..776acc7 100644[m
[1m--- a/package-lock.json[m
[1m+++ b/package-lock.json[m
[36m@@ -7187,6 +7187,11 @@[m
       "integrity": "sha1-yobR/ogoFpsBICCOPchCS524NCw=",[m
       "dev": true[m
     },[m
[32m+[m[32m    "ngx-bootstrap": {[m
[32m+[m[32m      "version": "2.0.5",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/ngx-bootstrap/-/ngx-bootstrap-2.0.5.tgz",[m
[32m+[m[32m      "integrity": "sha512-IduTVb78RDVlrz2+bn6GXK/REfM/RsRnz/AENwmrgTOg1AtvahJ9qANxXRNn33Kv9GJmkOYy/MhD3DyzeMb16w=="[m
[32m+[m[32m    },[m
     "no-case": {[m
       "version": "2.3.2",[m
       "resolved": "https://registry.npmjs.org/no-case/-/no-case-2.3.2.tgz",[m
[1mdiff --git a/package.json b/package.json[m
[1mindex 1a21767..1961540 100644[m
[1m--- a/package.json[m
[1m+++ b/package.json[m
[36m@@ -25,6 +25,7 @@[m
     "angular5-social-login": "^1.0.9",[m
     "bootstrap": "^3.3.7",[m
     "core-js": "^2.4.1",[m
[32m+[m[32m    "ngx-bootstrap": "^2.0.5",[m
     "rxjs": "^5.5.6",[m
     "zone.js": "^0.8.19"[m
   },[m
[1mdiff --git a/src/app/adress/adress.component.ts b/src/app/adress/adress.component.ts[m
[1mindex 859da18..cf8d03c 100644[m
[1m--- a/src/app/adress/adress.component.ts[m
[1m+++ b/src/app/adress/adress.component.ts[m
[36m@@ -11,7 +11,8 @@[m [mimport {Router} from '@angular/router';[m
 })[m
 export class AdressComponent implements OnInit {[m
     addressForm: FormGroup;[m
[31m-  constructor(private formBuilder: FormBuilder, private addressService: AddressService, private router: Router ) { }[m
[32m+[m[32m  constructor(private formBuilder: FormBuilder, private addressService: AddressService,[m
[32m+[m[32m              private router: Router ) { }[m
 [m
   ngOnInit() {[m
       this.initForm();[m
[36m@@ -20,15 +21,17 @@[m [mexport class AdressComponent implements OnInit {[m
         const name = localStorage.getItem('name');[m
         const familyName = localStorage.getItem('familyName');[m
         const phoneNumber = localStorage.getItem('phoneNumber');[m
[32m+[m[32m        const address = JSON.parse(localStorage.getItem('address'));[m
[32m+[m[32m    console.log( 'adresse ' + address);[m
         this.addressForm = this.formBuilder.group({[m
             customerName: name,[m
             familyName: familyName,[m
             phoneNumber: phoneNumber,[m
[31m-            country: ['', Validators.required],[m
[31m-            city: ['', Validators.required],[m
[31m-            address: ['', Validators.required],[m
[31m-            name: ['', Validators.required],[m
[31m-            postal_code: ['', Validators.required],[m
[32m+[m[32m            country: [address.country, Validators.required],[m
[32m+[m[32m            city: [address.city, Validators.required],[m
[32m+[m[32m            address: [address.address, Validators.required],[m
[32m+[m[32m            name: [address.name, Validators.required],[m
[32m+[m[32m            postal_code: [address.postal_code, Validators.required],[m
         });[m
     }[m
     onSubmitForm() {[m
[1mdiff --git a/src/app/app.module.ts b/src/app/app.module.ts[m
[1mindex 2501316..f5d2fbe 100644[m
[1m--- a/src/app/app.module.ts[m
[1m+++ b/src/app/app.module.ts[m
[36m@@ -35,9 +35,9 @@[m [mimport { AdressComponent } from './adress/adress.component';[m
 import {AddressService} from './services/address.service';[m
 import { PaymentComponent } from './payment/payment.component';[m
 import { ConfirmationComponent } from './confirmation/confirmation.component';[m
[31m-import { ConfirmationModalComponent } from './confirmation-modal/confirmation-modal.component';[m
 import { LoadingComponent } from './loading/loading.component';[m
[31m-[m
[32m+[m[32mimport { ModalModule } from 'ngx-bootstrap/modal';[m
[32m+[m[32mimport { OrdersComponent } from './orders/orders.component';[m
 [m
 [m
 const appRoutes: Routes = [[m
[36m@@ -50,6 +50,7 @@[m [mconst appRoutes: Routes = [[m
     { path: 'address', canActivate: [AuthGuard], component: AdressComponent},[m
     { path: 'payment', canActivate: [AuthGuard], component: PaymentComponent},[m
     { path: 'confirmation', canActivate: [AuthGuard], component: ConfirmationComponent},[m
[32m+[m[32m    { path: 'orders', canActivate: [AuthGuard], component: OrdersComponent},[m
     { path: 'clothes',  component: ClothesComponent},[m
     { path: 'beauty',  component: BeautyComponent},[m
     { path: 'HighTec',  component: HighTecComponent},[m
[36m@@ -111,8 +112,8 @@[m [mconst appRoutes: Routes = [[m
     AdressComponent,[m
     PaymentComponent,[m
     ConfirmationComponent,[m
[31m-    ConfirmationModalComponent,[m
     LoadingComponent,[m
[32m+[m[32m    OrdersComponent,[m
   ],[m
   imports: [[m
     BrowserModule,[m
[36m@@ -120,6 +121,7 @@[m [mconst appRoutes: Routes = [[m
     FormsModule,[m
     ReactiveFormsModule,[m
     RouterModule.forRoot(appRoutes),[m
[32m+[m[32m    ModalModule.forRoot(),[m
   ],[m
   providers: [[m
       BrandService,[m
[1mdiff --git a/src/app/basket-list/basket-list.component.html b/src/app/basket-list/basket-list.component.html[m
[1mindex a6e9be3..9a8d2d3 100644[m
[1m--- a/src/app/basket-list/basket-list.component.html[m
[1m+++ b/src/app/basket-list/basket-list.component.html[m
[36m@@ -33,8 +33,6 @@[m
 [m
 [m
 [m
[31m-[m
[31m-[m
 <!--basket-->[m
 <div class="container" id="main">[m
     <h2 class="pink">Mon Panier</h2>[m
[36m@@ -65,11 +63,31 @@[m
                         </div>[m
                     </div>[m
                     <div class="col-2 col-sm-2 col-md-2 text-right">[m
[31m-                        <button type="button" class="btn btn-outline-danger btn-xs" (click)="onDelete(product.id, product.price)">[m
[32m+[m[32m                        <button type="button" class="btn btn-outline-danger btn-xs" (click)="openModal(template)">[m
                             <i class="fa fa-trash" aria-hidden="true"></i>[m
                         </button>[m
                     </div>[m
                 </div>[m
[32m+[m
[32m+[m[32m                <ng-template #template>[m
[32m+[m[32m                    <div class="modal-content " >[m
[32m+[m[32m                        <div class="modal-header">[m
[32m+[m[32m                            <button type="button" class="close pull-right" aria-label="Close" (click)="modalRef.hide()">[m
[32m+[m[32m                                <span aria-hidden="true">&times;</span>[m
[32m+[m[32m                            </button>[m
[32m+[m[32m                            <div class="icon-box" >[m
[32m+[m[32m                                <b style="color:green;font-size: 46px;">!</b>[m
[32m+[m[32m                            </div>[m
[32m+[m[32m                            <h4 class="modal-title">Êtes-vous sûr ?</h4>[m
[32m+[m[32m                        </div>[m
[32m+[m
[32m+[m
[32m+[m[32m                            <button type="button" class="btn btn-info" aria-label="Close" (click)="modalRef.hide()"><span class="fa fa-close" > </span> Quitter</button>[m
[32m+[m[32m                            <button class="btn btn-success" type="submit" (click)="onDelete(product.id, product.price)"><span class="fa fa-check-circle"> </span> Confirmer</button>[m
[32m+[m
[32m+[m[32m                    </div>[m
[32m+[m[32m                </ng-template>[m
[32m+[m
             </div>[m
             <hr>[m
             <br>[m
[36m@@ -87,4 +105,6 @@[m
             </div>[m
         </div>[m
     </div>[m
[31m-</div>[m
\ No newline at end of file[m
[32m+[m[32m</div>[m
[41m+[m
[41m+[m
[1mdiff --git a/src/app/basket-list/basket-list.component.scss b/src/app/basket-list/basket-list.component.scss[m
[1mindex 8a04ac3..069f3d7 100644[m
[1m--- a/src/app/basket-list/basket-list.component.scss[m
[1m+++ b/src/app/basket-list/basket-list.component.scss[m
[36m@@ -92,4 +92,54 @@[m
 .bs-wizard > .bs-wizard-step.disabled > .bs-wizard-dot:after {opacity: 0;}[m
 .bs-wizard > .bs-wizard-step:first-child  > .progress {left: 50%; width: 50%;}[m
 .bs-wizard > .bs-wizard-step:last-child  > .progress {width: 50%;}[m
[31m-.bs-wizard > .bs-wizard-step.disabled a.bs-wizard-dot{ pointer-events: none; }[m
\ No newline at end of file[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.disabled a.bs-wizard-dot{ pointer-events: none; }[m
[32m+[m
[32m+[m[32m/*modal css*/[m
[32m+[m[32m.modal-confirm {[m
[32m+[m[32m  color: #636363;[m
[32m+[m[32m  width: 400px;[m
[32m+[m[32m}[m
[32m+[m[32m .modal-content {[m
[32m+[m[32m  padding: 20px;[m
[32m+[m[32m  border-radius: 5px;[m
[32m+[m[32m  border: none;[m
[32m+[m[32m  text-align: center;[m
[32m+[m[32m  font-size: 14px;[m
[32m+[m[32m}[m
[32m+[m[32m .modal-header {[m
[32m+[m[32m  border-bottom: none;[m
[32m+[m[32m  position: relative;[m
[32m+[m[32m}[m
[32m+[m[32m.modal-confirm h4 {[m
[32m+[m[32m  text-align: center;[m
[32m+[m[32m  font-size: 26px;[m
[32m+[m[32m  margin: 30px 0 -10px;[m
[32m+[m[32m}[m
[32m+[m[32m.modal-confirm .close {[m
[32m+[m[32m  position: absolute;[m
[32m+[m[32m  top: -5px;[m
[32m+[m[32m  right: -2px;[m
[32m+[m[32m}[m
[32m+[m[32m.modal-body {[m
[32m+[m[32m  color: #ff4f81;[m
[32m+[m[32m}[m
[32m+[m[32m.modal-confirm .modal-footer {[m
[32m+[m[32m  border: none;[m
[32m+[m[32m  text-align: center;[m
[32m+[m[32m  border-radius: 5px;[m
[32m+[m[32m  font-size: 13px;[m
[32m+[m[32m  padding: 10px 15px 25px;[m
[32m+[m[32m}[m
[32m+[m[32m.modal-footer a {[m
[32m+[m[32m  color: #999;[m
[32m+[m[32m}[m
[32m+[m[32m/*the outer Circle*/[m
[32m+[m[32m.icon-box {[m
[32m+[m[32m  width: 80px;[m
[32m+[m[32m  height: 80px;[m
[32m+[m[32m  margin: 0 auto;[m
[32m+[m[32m  border-radius: 50%;[m
[32m+[m[32m  z-index: 9;[m
[32m+[m[32m  text-align: center;[m
[32m+[m[32m  border: 3px solid #f15e5e;[m
[32m+[m[32m}[m
\ No newline at end of file[m
[1mdiff --git a/src/app/basket-list/basket-list.component.ts b/src/app/basket-list/basket-list.component.ts[m
[1mindex deb6e53..01e5c8e 100644[m
[1m--- a/src/app/basket-list/basket-list.component.ts[m
[1m+++ b/src/app/basket-list/basket-list.component.ts[m
[36m@@ -1,7 +1,8 @@[m
[31m-import { Component, OnInit } from '@angular/core';[m
[32m+[m[32mimport {Component, OnInit, TemplateRef} from '@angular/core';[m
 import {ShopingService} from '../services/shoping.service';[m
 import {Subject} from 'rxjs/Subject';[m
 import {Subscription} from 'rxjs/Subscription';[m
[32m+[m[32mimport {BsModalRef, BsModalService} from 'ngx-bootstrap';[m
 [m
 @Component({[m
   selector: 'app-basket-list',[m
[36m@@ -14,7 +15,14 @@[m [mexport class BasketListComponent  {[m
     private val: Subject <any>;[m
     products;[m
     total;[m
[31m-    constructor(private _basketService: ShopingService) {[m
[32m+[m[32m    modalRef: BsModalRef;[m
[32m+[m[32m    openModal(template: TemplateRef<any>) {[m
[32m+[m[32m        this.modalRef = this.modalService.show(template);[m
[32m+[m[32m    }[m
[32m+[m[32m    closeModal() {[m
[32m+[m[32m        this.modalRef.hide();[m
[32m+[m[32m    }[m
[32m+[m[32m    constructor(private _basketService: ShopingService, private modalService: BsModalService) {[m
         this._basketService.initialse();[m
         this.products = this._basketService.getProducts();[m
         this.val = _basketService.itemCountSource;[m
[36m@@ -30,6 +38,7 @@[m [mexport class BasketListComponent  {[m
         this._basketService.remove(id, price);[m
         this.products = this._basketService.getProducts();[m
         this.total = this._basketService.totalPrice;[m
[32m+[m[32m        this.closeModal();[m
     }[m
     public onAdd(id, price) {[m
      this._basketService.increaseQuantity(id, price);[m
[1mdiff --git a/src/app/confirmation-modal/confirmation-modal.component.html b/src/app/confirmation-modal/confirmation-modal.component.html[m
[1mdeleted file mode 100644[m
[1mindex 0900256..0000000[m
[1m--- a/src/app/confirmation-modal/confirmation-modal.component.html[m
[1m+++ /dev/null[m
[36m@@ -1,19 +0,0 @@[m
[31m-<div id="myModal" class="modal fade">[m
[31m-  <div class="modal-dialog modal-confirm modal-md">[m
[31m-    <div class="modal-content">[m
[31m-      <div class="modal-header">[m
[31m-        <div class="icon-box" >[m
[31m-          <b style="color:green;font-size: 46px;">!</b>[m
[31m-        </div>[m
[31m-        <h4 class="modal-title">Êtes-vous sûr ?</h4>[m
[31m-        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>[m
[31m-      </div>[m
[31m-      <div class="modal-body">[m
[31m-      </div>[m
[31m-      <div class="modal-footer">[m
[31m-          <button type="button" class="btn btn-info " data-dismiss="modal"><span class="fa fa-close"> </span> Quitter</button>[m
[31m-          <button class="btn btn-success" type="submit" ><span class="fa fa-check-circle"> </span> Confirmer</button>[m
[31m-      </div>[m
[31m-    </div>[m
[31m-  </div>[m
[31m-</div>[m
\ No newline at end of file[m
[1mdiff --git a/src/app/confirmation-modal/confirmation-modal.component.scss b/src/app/confirmation-modal/confirmation-modal.component.scss[m
[1mdeleted file mode 100644[m
[1mindex 76f2888..0000000[m
[1m--- a/src/app/confirmation-modal/confirmation-modal.component.scss[m
[1m+++ /dev/null[m
[36m@@ -1,49 +0,0 @@[m
[31m-/*modal css*/[m
[31m-.modal-confirm {[m
[31m-  color: #636363;[m
[31m-  width: 400px;[m
[31m-}[m
[31m-.modal-confirm .modal-content {[m
[31m-  padding: 20px;[m
[31m-  border-radius: 5px;[m
[31m-  border: none;[m
[31m-  text-align: center;[m
[31m-  font-size: 14px;[m
[31m-}[m
[31m-.modal-confirm .modal-header {[m
[31m-  border-bottom: none;[m
[31m-  position: relative;[m
[31m-}[m
[31m-.modal-confirm h4 {[m
[31m-  text-align: center;[m
[31m-  font-size: 26px;[m
[31m-  margin: 30px 0 -10px;[m
[31m-}[m
[31m-.modal-confirm .close {[m
[31m-  position: absolute;[m
[31m-  top: -5px;[m
[31m-  right: -2px;[m
[31m-}[m
[31m-.modal-confirm .modal-body {[m
[31m-  color: #ff4f81;[m
[31m-}[m
[31m-.modal-confirm .modal-footer {[m
[31m-  border: none;[m
[31m-  text-align: center;[m
[31m-  border-radius: 5px;[m
[31m-  font-size: 13px;[m
[31m-  padding: 10px 15px 25px;[m
[31m-}[m
[31m-.modal-confirm .modal-footer a {[m
[31m-  color: #999;[m
[31m-}[m
[31m-/*the outer Circle*/[m
[31m-.modal-confirm .icon-box {[m
[31m-  width: 80px;[m
[31m-  height: 80px;[m
[31m-  margin: 0 auto;[m
[31m-  border-radius: 50%;[m
[31m-  z-index: 9;[m
[31m-  text-align: center;[m
[31m-  border: 3px solid #f15e5e;[m
[31m-}[m
\ No newline at end of file[m
[1mdiff --git a/src/app/confirmation-modal/confirmation-modal.component.ts b/src/app/confirmation-modal/confirmation-modal.component.ts[m
[1mdeleted file mode 100644[m
[1mindex e379a40..0000000[m
[1m--- a/src/app/confirmation-modal/confirmation-modal.component.ts[m
[1m+++ /dev/null[m
[36m@@ -1,15 +0,0 @@[m
[31m-import { Component, OnInit } from '@angular/core';[m
[31m-[m
[31m-@Component({[m
[31m-  selector: 'app-confirmation-modal',[m
[31m-  templateUrl: './confirmation-modal.component.html',[m
[31m-  styleUrls: ['./confirmation-modal.component.scss'][m
[31m-})[m
[31m-export class ConfirmationModalComponent implements OnInit {[m
[31m-[m
[31m-  constructor() { }[m
[31m-[m
[31m-  ngOnInit() {[m
[31m-  }[m
[31m-[m
[31m-}[m
[1mdiff --git a/src/app/orders/orders.component.html b/src/app/orders/orders.component.html[m
[1mnew file mode 100644[m
[1mindex 0000000..ccbe439[m
[1m--- /dev/null[m
[1m+++ b/src/app/orders/orders.component.html[m
[36m@@ -0,0 +1,7 @@[m
[32m+[m[32m<div class="container" style="margin-top: 50px;" >[m
[32m+[m[32m  <div *ngFor="let order of orders; let i = index;" >[m
[32m+[m[32m    {{order.id}}[m
[32m+[m[32m      {{order.amount}}[m
[32m+[m[32m      <button (click)="onDelete(order.id)">annuler commande </button>[m
[32m+[m[32m  </div>[m
[32m+[m[32m</div>[m
[1mdiff --git a/src/app/orders/orders.component.scss b/src/app/orders/orders.component.scss[m
[1mnew file mode 100644[m
[1mindex 0000000..e69de29[m
[1mdiff --git a/src/app/orders/orders.component.ts b/src/app/orders/orders.component.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..54fddf6[m
[1m--- /dev/null[m
[1m+++ b/src/app/orders/orders.component.ts[m
[36m@@ -0,0 +1,27 @@[m
[32m+[m[32mimport { Component, OnInit } from '@angular/core';[m
[32m+[m[32mimport {Subscription} from 'rxjs/Subscription';[m
[32m+[m[32mimport {ShopingService} from '../services/shoping.service';[m
[32m+[m
[32m+[m[32m@Component({[m
[32m+[m[32m  selector: 'app-orders',[m
[32m+[m[32m  templateUrl: './orders.component.html',[m
[32m+[m[32m  styleUrls: ['./orders.component.scss'][m
[32m+[m[32m})[m
[32m+[m[32mexport class OrdersComponent implements OnInit {[m
[32m+[m[32m   orders: any[];[m
[32m+[m[32m    orderSubscription: Subscription;[m
[32m+[m[32m  constructor(private shopingService: ShopingService) { }[m
[32m+[m
[32m+[m[32m    ngOnInit() {[m
[32m+[m[32m        this.orderSubscription = this.shopingService.orderSubject.subscribe([m
[32m+[m[32m            (orders: any[]) => {[m
[32m+[m[32m                this.orders = orders;[m
[32m+[m[32m            }[m
[32m+[m[32m        );[m
[32m+[m[32m        this.shopingService.emitOrderSubject();[m
[32m+[m[32m        this.shopingService.getOrders();[m
[32m+[m[32m    }[m
[32m+[m[32m    onDelete(id) {[m
[32m+[m[32m        this.shopingService.cancelOrder(id);[m
[32m+[m[32m    }[m
[32m+[m[32m}[m
[1mdiff --git a/src/app/services/address.service.ts b/src/app/services/address.service.ts[m
[1mindex e4bda12..9ea4ebd 100644[m
[1m--- a/src/app/services/address.service.ts[m
[1m+++ b/src/app/services/address.service.ts[m
[36m@@ -11,18 +11,12 @@[m [mexport class AddressService {[m
     public emitAddressSubject() {[m
         this.addressSubject.next(this.addresses.slice());[m
     }[m
[31m-    /*public getAddresses() {[m
[31m-        this.httpClient.get<any[]>('http://localhost:8888/pfe_marketplace/web/app_dev.php/api/customers/addresses').subscribe([m
[31m-            (response) => {this.addresses = response;[m
[31m-                this.emitAddressSubject();[m
[31m-            },[m
[31m-            (error) => {console.log('Erreur ! :' + error); }[m
[31m-        );[m
[31m-    }*/[m
     saveToServer(body: any) {[m
         const customerId = localStorage.getItem('id');[m
         const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/customers/addresses/' + customerId;[m
         const b = JSON.stringify(body);[m
[32m+[m[32m        localStorage.setItem('address', b);[m
[32m+[m
         this.httpClient.post(url, b, {[m
             headers: {'Content-Type': 'application/json'}[m
         })[m
[1mdiff --git a/src/app/services/customer.service.ts b/src/app/services/customer.service.ts[m
[1mindex f6f1d45..adae068 100644[m
[1m--- a/src/app/services/customer.service.ts[m
[1m+++ b/src/app/services/customer.service.ts[m
[36m@@ -50,6 +50,7 @@[m [mexport class CustomerService {[m
             localStorage.setItem('birthDate', customer.birth_date);[m
             localStorage.setItem('phoneNumber', customer.phone_number);[m
             localStorage.setItem('pwd', pwd);[m
[32m+[m[32m            localStorage.setItem('address', JSON.stringify(customer.addresses[customer.addresses.length - 1 ]));[m
             return true;[m
         } else {return false; }[m
     }[m
[1mdiff --git a/src/app/services/delivry.service.ts b/src/app/services/delivry.service.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..696acc1[m
[1m--- /dev/null[m
[1m+++ b/src/app/services/delivry.service.ts[m
[36m@@ -0,0 +1,8 @@[m
[32m+[m[32mimport { Injectable } from '@angular/core';[m
[32m+[m
[32m+[m[32m@Injectable()[m
[32m+[m[32mexport class DelivryService {[m
[32m+[m
[32m+[m[32m  constructor() { }[m
[32m+[m
[32m+[m[32m}[m
[1mdiff --git a/src/app/services/shoping.service.ts b/src/app/services/shoping.service.ts[m
[1mindex 12d3fa2..e9a2add 100644[m
[1m--- a/src/app/services/shoping.service.ts[m
[1m+++ b/src/app/services/shoping.service.ts[m
[36m@@ -3,6 +3,7 @@[m [mimport {BehaviorSubject} from 'rxjs/BehaviorSubject';[m
 import {HttpClient} from '@angular/common/http';[m
 import {Item} from '../models/Item.model';[m
 import {Order} from '../models/Order.model';[m
[32m+[m[32mimport {Subject} from 'rxjs/Subject';[m
 [m
 @Injectable()[m
 export class ShopingService {[m
[36m@@ -10,6 +11,8 @@[m [mexport class ShopingService {[m
      itemCountSource = new BehaviorSubject(0);[m
     itemCount$ = this.itemCountSource.asObservable();[m
     totalPrice: number;[m
[32m+[m[32m    orders = [];[m
[32m+[m[32m    orderSubject = new Subject<any[]>();[m
     private products = [];[m
     constructor(private httpClient: HttpClient) {[m
         this.itemCount = 0;[m
[36m@@ -122,4 +125,25 @@[m [mexport class ShopingService {[m
         localStorage.removeItem('total');[m
         localStorage.removeItem('itemCount');[m
     }[m
[32m+[m[32m    public emitOrderSubject() {[m
[32m+[m[32m        this.orderSubject.next(this.orders.slice());[m
[32m+[m[32m    }[m
[32m+[m[32m    public getOrders() {[m
[32m+[m[32m        const customerId = localStorage.getItem('id');[m
[32m+[m[32m        this.httpClient.get<any[]>('http://localhost:8888/pfe_marketplace/web/app_dev.php/api/orders/' + customerId).subscribe([m
[32m+[m[32m            (response) => {this.orders = response;[m
[32m+[m[32m                this.emitOrderSubject();[m
[32m+[m[32m            },[m
[32m+[m[32m            (error) => {console.log('Erreur ! :' + error); }[m
[32m+[m[32m        );[m
[32m+[m[32m    }[m
[32m+[m[32m    public cancelOrder(id) {[m
[32m+[m[32m        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/orders/cancel/' + id;[m
[32m+[m[32m        this.httpClient.put(url, [], {[m
[32m+[m[32m            headers: {'Content-Type': 'application/json'}[m
[32m+[m[32m        })[m
[32m+[m[32m            .subscribe([m
[32m+[m[32m                () => {}, (error) => {console.log( 'erreur' + error); }[m
[32m+[m[32m            );[m
[32m+[m[32m    }[m
 }[m
[1mdiff --git a/src/app/top-nav/top-nav.component.html b/src/app/top-nav/top-nav.component.html[m
[1mindex eac8747..c234900 100644[m
[1m--- a/src/app/top-nav/top-nav.component.html[m
[1m+++ b/src/app/top-nav/top-nav.component.html[m
[36m@@ -51,8 +51,8 @@[m
                 <div class="dropdown">[m
                     <li *ngIf="isAuth"><a href="#"><i class="fa fa-user" aria-hidden="true"></i></a> </li>[m
                     <div class="dropdown-content ">[m
[31m-                        <a href="#"><i class="fa fa-list" aria-hidden="true"></i>  Mes Commandes</a>[m
[31m-                        <a href="#"><i class="fa fa-tag" aria-hidden="true"></i>  Mes Avantages</a>[m
[32m+[m[32m                        <a routerLink="orders"><i class="fa fa-list" aria-hidden="true"></i>  Mes Commandes</a>[m
[32m+[m[32m                      <!--  <a href="#"><i class="fa fa-tag" aria-hidden="true"></i>  Mes Avantages</a>-->[m
                         <a routerLink="profile"><i class="fa fa-user" aria-hidden="true"></i> Mon Profil</a>[m
                         <a (click)="onLogOut()"><i class="fa fa-power-off" aria-hidden="true"></i>  Déconnexion</a>[m
                     </div>[m

[33mcommit bc8a0069cd3ccf71162679c9187e84bef2789463[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Fri May 11 15:01:19 2018 +0100

    update shoping service

[1mdiff --git a/src/app/app.component.html b/src/app/app.component.html[m
[1mindex cfe3d2f..d404ff0 100644[m
[1m--- a/src/app/app.component.html[m
[1m+++ b/src/app/app.component.html[m
[36m@@ -1,3 +1,3 @@[m
 <app-top-nav ></app-top-nav>[m
 <router-outlet ></router-outlet>[m
[31m-<app-footer  ></app-footer>[m
\ No newline at end of file[m
[32m+[m[32m<app-footer  ></app-footer>[m
[1mdiff --git a/src/app/app.module.ts b/src/app/app.module.ts[m
[1mindex 81df9f5..2501316 100644[m
[1m--- a/src/app/app.module.ts[m
[1m+++ b/src/app/app.module.ts[m
[36m@@ -36,6 +36,7 @@[m [mimport {AddressService} from './services/address.service';[m
 import { PaymentComponent } from './payment/payment.component';[m
 import { ConfirmationComponent } from './confirmation/confirmation.component';[m
 import { ConfirmationModalComponent } from './confirmation-modal/confirmation-modal.component';[m
[32m+[m[32mimport { LoadingComponent } from './loading/loading.component';[m
 [m
 [m
 [m
[36m@@ -111,6 +112,7 @@[m [mconst appRoutes: Routes = [[m
     PaymentComponent,[m
     ConfirmationComponent,[m
     ConfirmationModalComponent,[m
[32m+[m[32m    LoadingComponent,[m
   ],[m
   imports: [[m
     BrowserModule,[m
[1mdiff --git a/src/app/brand-list/brand-list.component.html b/src/app/brand-list/brand-list.component.html[m
[1mindex 42ca482..929b881 100644[m
[1m--- a/src/app/brand-list/brand-list.component.html[m
[1m+++ b/src/app/brand-list/brand-list.component.html[m
[36m@@ -1,8 +1,9 @@[m
[31m-<div class="container" style="margin-top: 50px;" >[m
[32m+[m[32m<div class="container" style="margin-top: 50px;" *ngIf="!isLoading">[m
     <app-brand *ngFor="let brand of brands; let i = index;" [brandName]="brand.brand_name"[m
                [id]="brand.id" [description]="brand.description"  [image]="brand.brand_image.name"[m
                [logo]="brand.logo.name"  [categories]="brand.categories">[m
     </app-brand>[m
 </div>[m
 [m
[32m+[m[32m<app-loading *ngIf="isLoading"></app-loading>[m
 [m
[1mdiff --git a/src/app/brand-list/brand-list.component.ts b/src/app/brand-list/brand-list.component.ts[m
[1mindex 4bad132..4e37f80 100644[m
[1m--- a/src/app/brand-list/brand-list.component.ts[m
[1m+++ b/src/app/brand-list/brand-list.component.ts[m
[36m@@ -10,6 +10,7 @@[m [mimport {BrandService} from '../services/brand.service';[m
 export class BrandListComponent implements OnInit {[m
     brands: any[];[m
     brandSubscription: Subscription;[m
[32m+[m[32m    isLoading = true;[m
     constructor( private brandService: BrandService) {[m
     }[m
     ngOnInit() {[m
[36m@@ -20,6 +21,7 @@[m [mexport class BrandListComponent implements OnInit {[m
         );[m
         this.brandService.emitBrandSubject();[m
             this.onFetch() ;[m
[32m+[m[32m        this.isLoading = false;[m
     }[m
     onFetch() {[m
         this.brandService.getBrands();[m
[1mdiff --git a/src/app/confirmation/confirmation.component.ts b/src/app/confirmation/confirmation.component.ts[m
[1mindex ace0647..a715a08 100644[m
[1m--- a/src/app/confirmation/confirmation.component.ts[m
[1m+++ b/src/app/confirmation/confirmation.component.ts[m
[36m@@ -11,6 +11,7 @@[m [mexport class ConfirmationComponent implements OnInit {[m
   constructor(private shopingService: ShopingService) { }[m
 [m
   ngOnInit() {[m
[32m+[m[32m      this.shopingService.initialse();[m
     this.shopingService.saveItems();[m
   }[m
 [m
[1mdiff --git a/src/app/home/home.component.html b/src/app/home/home.component.html[m
[1mindex afe4f52..345f2ab 100644[m
[1m--- a/src/app/home/home.component.html[m
[1m+++ b/src/app/home/home.component.html[m
[36m@@ -1 +1,2 @@[m
 <app-brand-list></app-brand-list>[m
[41m+[m
[1mdiff --git a/src/app/loading/loading.component.html b/src/app/loading/loading.component.html[m
[1mnew file mode 100644[m
[1mindex 0000000..8f09891[m
[1m--- /dev/null[m
[1m+++ b/src/app/loading/loading.component.html[m
[36m@@ -0,0 +1,2 @@[m
[32m+[m[32m<img src="assets/images/arrow.png">[m
[32m+[m[32m<h2>hamdi loading</h2>[m
[1mdiff --git a/src/app/loading/loading.component.scss b/src/app/loading/loading.component.scss[m
[1mnew file mode 100644[m
[1mindex 0000000..e69de29[m
[1mdiff --git a/src/app/loading/loading.component.ts b/src/app/loading/loading.component.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..1c7f98f[m
[1m--- /dev/null[m
[1m+++ b/src/app/loading/loading.component.ts[m
[36m@@ -0,0 +1,15 @@[m
[32m+[m[32mimport { Component, OnInit } from '@angular/core';[m
[32m+[m
[32m+[m[32m@Component({[m
[32m+[m[32m  selector: 'app-loading',[m
[32m+[m[32m  templateUrl: './loading.component.html',[m
[32m+[m[32m  styleUrls: ['./loading.component.scss'][m
[32m+[m[32m})[m
[32m+[m[32mexport class LoadingComponent implements OnInit {[m
[32m+[m
[32m+[m[32m  constructor() { }[m
[32m+[m
[32m+[m[32m  ngOnInit() {[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m}[m
[1mdiff --git a/src/app/product/product.component.html b/src/app/product/product.component.html[m
[1mindex a55fe00..b0c7f83 100644[m
[1m--- a/src/app/product/product.component.html[m
[1m+++ b/src/app/product/product.component.html[m
[36m@@ -1,4 +1,4 @@[m
[31m-<div class="col-md-4 product-men">[m
[32m+[m[32m<div class="col-md-4 product-men" *ngIf="quantity>0">[m
     <div class="men-pro-item simpleCart_shelfItem" style="min-height:450px;">[m
         <div class="men-thumb-item">[m
             <img [src]="url+images[0].name" alt="" class="pro-image-front">[m
[1mdiff --git a/src/app/services/shoping.service.ts b/src/app/services/shoping.service.ts[m
[1mindex c314e7e..12d3fa2 100644[m
[1m--- a/src/app/services/shoping.service.ts[m
[1m+++ b/src/app/services/shoping.service.ts[m
[36m@@ -26,6 +26,11 @@[m [mexport class ShopingService {[m
             .subscribe([m
                 () => {}, (error) => {console.log( b + 'erreur' + error); }[m
             );[m
[32m+[m[32m        this.destroy();[m
[32m+[m[32m        this.products = [];[m
[32m+[m[32m        this.itemCount = 0;[m
[32m+[m[32m        this.itemCountSource.next(0);[m
[32m+[m[32m        this.totalPrice = 0.0;[m
     }[m
     public saveItems () {[m
         const items = [] ;[m
[36m@@ -112,4 +117,9 @@[m [mexport class ShopingService {[m
             this.itemCountSource.next(this.itemCount);[m
         }[m
     }[m
[32m+[m[32m    public destroy() {[m
[32m+[m[32m        localStorage.removeItem('shopingList');[m
[32m+[m[32m        localStorage.removeItem('total');[m
[32m+[m[32m        localStorage.removeItem('itemCount');[m
[32m+[m[32m    }[m
 }[m

[33mcommit f0771c2c0016c80fec1f5b6ecaa95a2763fd68dc[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Fri May 11 12:51:46 2018 +0100

    fix cart issue

[1mdiff --git a/src/app/app.module.ts b/src/app/app.module.ts[m
[1mindex 8b34667..81df9f5 100644[m
[1m--- a/src/app/app.module.ts[m
[1m+++ b/src/app/app.module.ts[m
[36m@@ -35,6 +35,7 @@[m [mimport { AdressComponent } from './adress/adress.component';[m
 import {AddressService} from './services/address.service';[m
 import { PaymentComponent } from './payment/payment.component';[m
 import { ConfirmationComponent } from './confirmation/confirmation.component';[m
[32m+[m[32mimport { ConfirmationModalComponent } from './confirmation-modal/confirmation-modal.component';[m
 [m
 [m
 [m
[36m@@ -45,9 +46,9 @@[m [mconst appRoutes: Routes = [[m
     { path: '', component: HomeComponent},[m
     /*basket-list*/[m
     { path: 'basket', component: BasketListComponent},[m
[31m-    { path: 'address', component: AdressComponent},[m
[31m-    { path: 'payment', component: PaymentComponent},[m
[31m-    { path: 'confirmation', component: ConfirmationComponent},[m
[32m+[m[32m    { path: 'address', canActivate: [AuthGuard], component: AdressComponent},[m
[32m+[m[32m    { path: 'payment', canActivate: [AuthGuard], component: PaymentComponent},[m
[32m+[m[32m    { path: 'confirmation', canActivate: [AuthGuard], component: ConfirmationComponent},[m
     { path: 'clothes',  component: ClothesComponent},[m
     { path: 'beauty',  component: BeautyComponent},[m
     { path: 'HighTec',  component: HighTecComponent},[m
[36m@@ -109,6 +110,7 @@[m [mconst appRoutes: Routes = [[m
     AdressComponent,[m
     PaymentComponent,[m
     ConfirmationComponent,[m
[32m+[m[32m    ConfirmationModalComponent,[m
   ],[m
   imports: [[m
     BrowserModule,[m
[1mdiff --git a/src/app/basket-list/basket-list.component.ts b/src/app/basket-list/basket-list.component.ts[m
[1mindex 89661bf..deb6e53 100644[m
[1m--- a/src/app/basket-list/basket-list.component.ts[m
[1m+++ b/src/app/basket-list/basket-list.component.ts[m
[36m@@ -15,13 +15,14 @@[m [mexport class BasketListComponent  {[m
     products;[m
     total;[m
     constructor(private _basketService: ShopingService) {[m
[32m+[m[32m        this._basketService.initialse();[m
[32m+[m[32m        this.products = this._basketService.getProducts();[m
         this.val = _basketService.itemCountSource;[m
         this.itemCount = 0;[m
         this.subscription = _basketService.itemCount$.subscribe([m
             data => {[m
                 this.itemCount = data;[m
             });[m
[31m-        this.products = this._basketService.getProducts();[m
         this.total = this._basketService.totalPrice;[m
     }[m
 [m
[1mdiff --git a/src/app/confirmation-modal/confirmation-modal.component.html b/src/app/confirmation-modal/confirmation-modal.component.html[m
[1mnew file mode 100644[m
[1mindex 0000000..0900256[m
[1m--- /dev/null[m
[1m+++ b/src/app/confirmation-modal/confirmation-modal.component.html[m
[36m@@ -0,0 +1,19 @@[m
[32m+[m[32m<div id="myModal" class="modal fade">[m
[32m+[m[32m  <div class="modal-dialog modal-confirm modal-md">[m
[32m+[m[32m    <div class="modal-content">[m
[32m+[m[32m      <div class="modal-header">[m
[32m+[m[32m        <div class="icon-box" >[m
[32m+[m[32m          <b style="color:green;font-size: 46px;">!</b>[m
[32m+[m[32m        </div>[m
[32m+[m[32m        <h4 class="modal-title">Êtes-vous sûr ?</h4>[m
[32m+[m[32m        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>[m
[32m+[m[32m      </div>[m
[32m+[m[32m      <div class="modal-body">[m
[32m+[m[32m      </div>[m
[32m+[m[32m      <div class="modal-footer">[m
[32m+[m[32m          <button type="button" class="btn btn-info " data-dismiss="modal"><span class="fa fa-close"> </span> Quitter</button>[m
[32m+[m[32m          <button class="btn btn-success" type="submit" ><span class="fa fa-check-circle"> </span> Confirmer</button>[m
[32m+[m[32m      </div>[m
[32m+[m[32m    </div>[m
[32m+[m[32m  </div>[m
[32m+[m[32m</div>[m
\ No newline at end of file[m
[1mdiff --git a/src/app/confirmation-modal/confirmation-modal.component.scss b/src/app/confirmation-modal/confirmation-modal.component.scss[m
[1mnew file mode 100644[m
[1mindex 0000000..76f2888[m
[1m--- /dev/null[m
[1m+++ b/src/app/confirmation-modal/confirmation-modal.component.scss[m
[36m@@ -0,0 +1,49 @@[m
[32m+[m[32m/*modal css*/[m
[32m+[m[32m.modal-confirm {[m
[32m+[m[32m  color: #636363;[m
[32m+[m[32m  width: 400px;[m
[32m+[m[32m}[m
[32m+[m[32m.modal-confirm .modal-content {[m
[32m+[m[32m  padding: 20px;[m
[32m+[m[32m  border-radius: 5px;[m
[32m+[m[32m  border: none;[m
[32m+[m[32m  text-align: center;[m
[32m+[m[32m  font-size: 14px;[m
[32m+[m[32m}[m
[32m+[m[32m.modal-confirm .modal-header {[m
[32m+[m[32m  border-bottom: none;[m
[32m+[m[32m  position: relative;[m
[32m+[m[32m}[m
[32m+[m[32m.modal-confirm h4 {[m
[32m+[m[32m  text-align: center;[m
[32m+[m[32m  font-size: 26px;[m
[32m+[m[32m  margin: 30px 0 -10px;[m
[32m+[m[32m}[m
[32m+[m[32m.modal-confirm .close {[m
[32m+[m[32m  position: absolute;[m
[32m+[m[32m  top: -5px;[m
[32m+[m[32m  right: -2px;[m
[32m+[m[32m}[m
[32m+[m[32m.modal-confirm .modal-body {[m
[32m+[m[32m  color: #ff4f81;[m
[32m+[m[32m}[m
[32m+[m[32m.modal-confirm .modal-footer {[m
[32m+[m[32m  border: none;[m
[32m+[m[32m  text-align: center;[m
[32m+[m[32m  border-radius: 5px;[m
[32m+[m[32m  font-size: 13px;[m
[32m+[m[32m  padding: 10px 15px 25px;[m
[32m+[m[32m}[m
[32m+[m[32m.modal-confirm .modal-footer a {[m
[32m+[m[32m  color: #999;[m
[32m+[m[32m}[m
[32m+[m[32m/*the outer Circle*/[m
[32m+[m[32m.modal-confirm .icon-box {[m
[32m+[m[32m  width: 80px;[m
[32m+[m[32m  height: 80px;[m
[32m+[m[32m  margin: 0 auto;[m
[32m+[m[32m  border-radius: 50%;[m
[32m+[m[32m  z-index: 9;[m
[32m+[m[32m  text-align: center;[m
[32m+[m[32m  border: 3px solid #f15e5e;[m
[32m+[m[32m}[m
\ No newline at end of file[m
[1mdiff --git a/src/app/confirmation-modal/confirmation-modal.component.ts b/src/app/confirmation-modal/confirmation-modal.component.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..e379a40[m
[1m--- /dev/null[m
[1m+++ b/src/app/confirmation-modal/confirmation-modal.component.ts[m
[36m@@ -0,0 +1,15 @@[m
[32m+[m[32mimport { Component, OnInit } from '@angular/core';[m
[32m+[m
[32m+[m[32m@Component({[m
[32m+[m[32m  selector: 'app-confirmation-modal',[m
[32m+[m[32m  templateUrl: './confirmation-modal.component.html',[m
[32m+[m[32m  styleUrls: ['./confirmation-modal.component.scss'][m
[32m+[m[32m})[m
[32m+[m[32mexport class ConfirmationModalComponent implements OnInit {[m
[32m+[m
[32m+[m[32m  constructor() { }[m
[32m+[m
[32m+[m[32m  ngOnInit() {[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m}[m
[1mdiff --git a/src/app/services/shoping.service.ts b/src/app/services/shoping.service.ts[m
[1mindex 1e5a662..c314e7e 100644[m
[1m--- a/src/app/services/shoping.service.ts[m
[1m+++ b/src/app/services/shoping.service.ts[m
[36m@@ -55,11 +55,16 @@[m [mexport class ShopingService {[m
         productObject.quantity = quantity;[m
         productObject.size = size;[m
         this.products.push(productObject);[m
[32m+[m[32m       this.storeData();[m
     }[m
     public getProducts () {[m
        return this.products;[m
     }[m
[31m-[m
[32m+[m[32m    public storeData() {[m
[32m+[m[32m        localStorage.setItem('shopingList', JSON.stringify(this.products));[m
[32m+[m[32m        localStorage.setItem('total', this.totalPrice.toString());[m
[32m+[m[32m        localStorage.setItem('itemCount', this.itemCount.toString());[m
[32m+[m[32m    }[m
     public remove (id, price) {[m
         const productIndexToRemove = this.products.findIndex([m
             (product) => {[m
[36m@@ -73,6 +78,7 @@[m [mexport class ShopingService {[m
         this.itemCount--;[m
         this.itemCountSource.next(this.itemCount);[m
         this.products.splice(productIndexToRemove, 1);[m
[32m+[m[32m        this.storeData();[m
     }[m
     public increaseQuantity(id, price) {[m
         const productIndexToRemove = this.products.findIndex([m
[36m@@ -84,6 +90,7 @@[m [mexport class ShopingService {[m
             }[m
         );[m
         this.totalPrice += price;[m
[32m+[m[32m        this.storeData();[m
     }[m
     public decreaseQuantity(id, price) {[m
         const productIndexToRemove = this.products.findIndex([m
[36m@@ -95,5 +102,14 @@[m [mexport class ShopingService {[m
             }[m
         );[m
         this.totalPrice -= price;[m
[32m+[m[32m        this.storeData();[m
[32m+[m[32m    }[m
[32m+[m[32m    public initialse() {[m
[32m+[m[32m        if (localStorage.getItem('itemCount')) {[m
[32m+[m[32m            this.products = JSON.parse(localStorage.getItem('shopingList'));[m
[32m+[m[32m            this.totalPrice = +localStorage.getItem('total');[m
[32m+[m[32m            this.itemCount = +localStorage.getItem('itemCount');[m
[32m+[m[32m            this.itemCountSource.next(this.itemCount);[m
[32m+[m[32m        }[m
     }[m
 }[m
[1mdiff --git a/src/app/signin/signin.component.ts b/src/app/signin/signin.component.ts[m
[1mindex 7b4c6a3..60012b9 100644[m
[1m--- a/src/app/signin/signin.component.ts[m
[1m+++ b/src/app/signin/signin.component.ts[m
[36m@@ -23,8 +23,8 @@[m [mexport class SigninComponent implements OnInit {[m
   }[m
     initForm() {[m
         this.loginForm = this.formBuilder.group({[m
[31m-            email: ['', [Validators.required, Validators.email]],[m
[31m-            pwd: ['', [Validators.required, Validators.minLength(8), Validators.pattern('^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$')]],[m
[32m+[m[32m            email: '',[m
[32m+[m[32m            pwd: '',[m
         });[m
     }[m
     onSubmitForm() {[m
[1mdiff --git a/src/app/top-nav/top-nav.component.ts b/src/app/top-nav/top-nav.component.ts[m
[1mindex 6f8152f..2116d36 100644[m
[1m--- a/src/app/top-nav/top-nav.component.ts[m
[1m+++ b/src/app/top-nav/top-nav.component.ts[m
[36m@@ -20,8 +20,8 @@[m [mexport class TopNavComponent implements OnInit {[m
     private val: Subject <any>;[m
     isAuth: string;[m
     constructor(private router: Router, private _basketService: ShopingService) {[m
[32m+[m[32m        this._basketService.initialse();[m
         this.val = _basketService.itemCountSource;[m
[31m-        this.itemCount = 0;[m
         this.subscription = _basketService.itemCount$.subscribe([m
             data => {[m
                 this.itemCount = data;[m

[33mcommit c1de441f5ad82b40522eac31d12491ea2594b469[m
Author: Nouha <nouha.bensalem1992@gmail.com>
Date:   Wed May 9 13:00:56 2018 +0100

    update the footer

[1mdiff --git a/src/app/footer/footer.component.html b/src/app/footer/footer.component.html[m
[1mindex d1df2f0..7c27561 100644[m
[1m--- a/src/app/footer/footer.component.html[m
[1m+++ b/src/app/footer/footer.component.html[m
[36m@@ -28,11 +28,8 @@[m
             <li><a routerLink="HighTec">High-Tec</a></li>[m
             <li><a routerLink="beauty">Beauté</a></li>[m
             <li><a routerLink="">Bijoux</a></li>[m
[31m-[m
[31m-[m
           </ul>[m
         </div>[m
[31m-[m
         <div class="col-md-5 sign-gd-two">[m
           <h4>Contact <span>Information</span></h4>[m
           <div class="w3-address">[m
[36m@@ -52,19 +49,7 @@[m
               </div>[m
               <div class="w3-address-right">[m
                 <h6>Addresse E-mail</h6>[m
[31m-                <p>Email :<a href="mailto:example@email.com">  sbzMarket@contact.com</a></p>[m
[31m-              </div>[m
[31m-              <div class="clearfix"> </div>[m
[31m-            </div>[m
[31m-            <div class="w3-address-grid">[m
[31m-              <div class="w3-address-left">[m
[31m-                <i class="fa fa-map-marker" aria-hidden="true"></i>[m
[31m-              </div>[m
[31m-              <div class="w3-address-right">[m
[31m-                <h6>Emplacement</h6>[m
[31m-                <p>France[m
[31m-[m
[31m-                </p>[m
[32m+[m[32m                <p>Email :<a href="mailto:example@email.com">  contact@sbzmarket.com</a></p>[m
               </div>[m
               <div class="clearfix"> </div>[m
             </div>[m

[33mcommit 995f2d165bf2bb69e17eef9edc21bbe24d21e766[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Wed May 9 11:24:50 2018 +0100

    udpate product Component

[1mdiff --git a/src/app/product/product.component.html b/src/app/product/product.component.html[m
[1mindex a000640..a55fe00 100644[m
[1m--- a/src/app/product/product.component.html[m
[1m+++ b/src/app/product/product.component.html[m
[36m@@ -19,14 +19,14 @@[m
             </div>[m
 [m
 [m
[31m-            <span *ngIf="sizes.length>0">[m
[32m+[m[32m            <!--<span *ngIf="sizes.length>0">[m
                     <p >Taille :</p>[m
                     <select  >[m
                         <option value="{{size.size}}" *ngFor="let size of sizes; let i = index;">[m
                             {{size.size}}[m
                         </option>[m
                     </select>[m
[31m-                </span>[m
[32m+[m[32m                </span>-->[m
 [m
 [m
 [m
[1mdiff --git a/src/app/product/product.component.ts b/src/app/product/product.component.ts[m
[1mindex 31dc073..9575bc3 100644[m
[1m--- a/src/app/product/product.component.ts[m
[1m+++ b/src/app/product/product.component.ts[m
[36m@@ -42,7 +42,7 @@[m [mexport class ProductComponent implements OnInit {[m
       }[m
   }[m
   onAdd(id, price , name, image) {[m
[31m-      this.shoping.AddToBasket(id, price , name, image, 1, 1);[m
[32m+[m[32m      this.shoping.AddToBasket(id, price , name, image, 1,  '');[m
       this.selected = true;[m
       this.basket = this.shoping.getProducts();[m
   }[m

[33mcommit 7753054bb1ef9051d87925ed8e0307d44ec2cc93[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Tue May 8 17:20:14 2018 +0100

    fix product component

[1mdiff --git a/src/app/product/product.component.ts b/src/app/product/product.component.ts[m
[1mindex 1a71624..31dc073 100644[m
[1m--- a/src/app/product/product.component.ts[m
[1m+++ b/src/app/product/product.component.ts[m
[36m@@ -42,7 +42,7 @@[m [mexport class ProductComponent implements OnInit {[m
       }[m
   }[m
   onAdd(id, price , name, image) {[m
[31m-      this.shoping.AddToBasket(id, price , name, image, 1);[m
[32m+[m[32m      this.shoping.AddToBasket(id, price , name, image, 1, 1);[m
       this.selected = true;[m
       this.basket = this.shoping.getProducts();[m
   }[m

[33mcommit 3068657133a912360491f0b681286a029818c27a[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Tue May 8 17:17:10 2018 +0100

    add size to service shiping

[1mdiff --git a/src/app/basket-list/basket-list.component.html b/src/app/basket-list/basket-list.component.html[m
[1mindex 608d049..a6e9be3 100644[m
[1m--- a/src/app/basket-list/basket-list.component.html[m
[1m+++ b/src/app/basket-list/basket-list.component.html[m
[36m@@ -49,6 +49,7 @@[m
                 </div>[m
                 <div class="col-12 text-sm-center col-sm-12 text-md-left col-md-6">[m
                     <h4 class="product-name"><strong>{{product.product_name}}</strong></h4>[m
[32m+[m[32m                    <p >{{product.size}}</p>[m
 [m
                 </div>[m
                 <div class="col-12 col-sm-12 text-sm-center col-md-4 text-md-right row">[m
[1mdiff --git a/src/app/models/Item.model.ts b/src/app/models/Item.model.ts[m
[1mindex 0989c3c..ff439b8 100644[m
[1m--- a/src/app/models/Item.model.ts[m
[1m+++ b/src/app/models/Item.model.ts[m
[36m@@ -3,5 +3,6 @@[m [mexport class Item {[m
     constructor([m
         public product: string,[m
         public quantity: string,[m
[32m+[m[32m        public size: string[m
     ) {}[m
 }[m
[1mdiff --git a/src/app/product-details/product-details.component.html b/src/app/product-details/product-details.component.html[m
[1mindex b11a4d9..e06a47f 100644[m
[1m--- a/src/app/product-details/product-details.component.html[m
[1m+++ b/src/app/product-details/product-details.component.html[m
[36m@@ -54,27 +54,28 @@[m
         <p><span class="item_price">{{product.price}}€</span> <del>- {{product.price}}€</del></p>[m
 [m
         <div class="color-quality" >[m
[32m+[m[32m            <form [formGroup]="itemForm" (ngSubmit)="onAdd(product.id,product.price,product.product_name,url+product.images[0].name)">[m
             <div class="color-quality-right">[m
                <span *ngIf="product.sizes.length>0">[m
                     <h5 >Taille :</h5>[m
[31m-                    <select id="" onchange="" class="frm-field required sect">[m
[31m-                        <option value="null" *ngFor="let size of product.sizes; let i = index;">[m
[32m+[m[32m                    <select id="" onchange="" class="frm-field required sect" formControlName="size">[m
[32m+[m[32m                        <option value="{{size.size}}" *ngFor="let size of product.sizes; let i = index;">[m
                             {{size.size}}[m
                         </option>[m
                     </select>[m
                 </span>[m
                 <h5 style="margin-top: 10px;">Quantité :</h5>[m
[31m-                <select id="quantity"  class="frm-field required sect">[m
[31m-                    <option value="null">1 </option>[m
[31m-                    <option value="null">2 </option>[m
[31m-                    <option value="null">3 </option>[m
[31m-                    <option value="null">4 </option>[m
[31m-                    <option value="null">5 </option>[m
[32m+[m[32m                <select id="quantity"  class="frm-field required sect" formControlName="quantity">[m
[32m+[m[32m                    <option value="1">1 </option>[m
[32m+[m[32m                    <option value="2">2 </option>[m
[32m+[m[32m                    <option value="3">3 </option>[m
[32m+[m[32m                    <option value="4">4 </option>[m
[32m+[m[32m                    <option value="5">5 </option>[m
                 </select>[m
[31m-[m
[31m-[m
             </div>[m
 [m
[32m+[m[32m            </form>[m
[32m+[m
         </div>[m
 [m
         <div class="occasion-cart">[m
[1mdiff --git a/src/app/product-details/product-details.component.ts b/src/app/product-details/product-details.component.ts[m
[1mindex 97122bc..f2d99df 100644[m
[1m--- a/src/app/product-details/product-details.component.ts[m
[1m+++ b/src/app/product-details/product-details.component.ts[m
[36m@@ -2,7 +2,7 @@[m [mimport {Component , OnInit} from '@angular/core';[m
 import {ActivatedRoute, Router} from '@angular/router';[m
 import {BrandService} from '../services/brand.service';[m
 import {ShopingService} from '../services/shoping.service';[m
[31m-import {FormGroup} from '@angular/forms';[m
[32m+[m[32mimport {FormBuilder, FormGroup, Validators} from '@angular/forms';[m
 [m
 @Component({[m
   selector: 'app-product-details',[m
[36m@@ -19,7 +19,9 @@[m [mexport class ProductDetailsComponent implements OnInit {[m
     basket ;[m
     selected = false;[m
     quantity;[m
[31m-    constructor(private brandService: BrandService, private router: ActivatedRoute, private shoping: ShopingService) {[m
[32m+[m[32m    itemForm: FormGroup;[m
[32m+[m[32m    constructor(private brandService: BrandService, private router: ActivatedRoute, private shoping: ShopingService,[m
[32m+[m[32m                private formBuilder: FormBuilder) {[m
         this.basket = this.shoping.getProducts();[m
         this.id = this.router.snapshot.params['id'];[m
         this.idc = +this.router.snapshot.params['idc'];[m
[36m@@ -32,9 +34,12 @@[m [mexport class ProductDetailsComponent implements OnInit {[m
         }[m
     }[m
     ngOnInit(): void {[m
[32m+[m[32m        this.initForm();[m
     }[m
     onAdd(id, price , name, image, quantity) {[m
[31m-        this.shoping.AddToBasket(id, price , name, image, 1);[m
[32m+[m[32m        const formValue = this.itemForm.value;[m
[32m+[m
[32m+[m[32m        this.shoping.AddToBasket(id, price , name, image, +formValue['quantity'], formValue['size']);[m
         this.selected = true;[m
         this.basket = this.shoping.getProducts();[m
     }[m
[36m@@ -43,4 +48,10 @@[m [mexport class ProductDetailsComponent implements OnInit {[m
         this.selected = false;[m
         this.basket = this.shoping.getProducts();[m
     }[m
[32m+[m[32m    initForm() {[m
[32m+[m[32m        this.itemForm = this.formBuilder.group({[m
[32m+[m[32m            quantity: ['1', [Validators.required]],[m
[32m+[m[32m            size: [ [Validators.required]][m
[32m+[m[32m        });[m
[32m+[m[32m    }[m
 }[m
[1mdiff --git a/src/app/product-list/product-list.component.html b/src/app/product-list/product-list.component.html[m
[1mindex 6dd974f..aa58ab5 100644[m
[1m--- a/src/app/product-list/product-list.component.html[m
[1m+++ b/src/app/product-list/product-list.component.html[m
[36m@@ -39,13 +39,13 @@[m
             <span *ngIf="!idc;">[m
                 <app-product *ngFor="let product of category.products; let i = index;" [productName]="product.product_name"[m
                              [id]="product.id" [price]="product.price" [quantity]="product.quantity" [images]="product.images"[m
[31m-                             [deleted]="product.deleted">[m
[32m+[m[32m                             [deleted]="product.deleted" [sizes]="product.sizes">[m
                 </app-product>[m
             </span>[m
             <span *ngIf="category.id === idc">[m
                 <app-product *ngFor="let product of category.products; let i = index;" [productName]="product.product_name"[m
                              [id]="product.id" [price]="product.price" [quantity]="product.quantity" [images]="product.images"[m
[31m-                             [deleted]="product.deleted">[m
[32m+[m[32m                             [deleted]="product.deleted" [sizes]="product.sizes">[m
                 </app-product>[m
             </span>[m
         </span>[m
[1mdiff --git a/src/app/product-list/product-list.component.ts b/src/app/product-list/product-list.component.ts[m
[1mindex 71c4c03..0262787 100644[m
[1m--- a/src/app/product-list/product-list.component.ts[m
[1m+++ b/src/app/product-list/product-list.component.ts[m
[36m@@ -1,7 +1,6 @@[m
 import { Component, OnInit } from '@angular/core';[m
 import {ActivatedRoute, Router} from '@angular/router';[m
 import {BrandService} from '../services/brand.service';[m
[31m-import {ShopingService} from '../services/shoping.service';[m
 [m
 @Component({[m
   selector: 'app-product-list',[m
[1mdiff --git a/src/app/product/product.component.html b/src/app/product/product.component.html[m
[1mindex 62677ea..a000640 100644[m
[1m--- a/src/app/product/product.component.html[m
[1m+++ b/src/app/product/product.component.html[m
[36m@@ -17,6 +17,19 @@[m
                 <span class="item_price">{{price}} €</span>[m
                 <del>{{price}} €</del>[m
             </div>[m
[32m+[m
[32m+[m
[32m+[m[32m            <span *ngIf="sizes.length>0">[m
[32m+[m[32m                    <p >Taille :</p>[m
[32m+[m[32m                    <select  >[m
[32m+[m[32m                        <option value="{{size.size}}" *ngFor="let size of sizes; let i = index;">[m
[32m+[m[32m                            {{size.size}}[m
[32m+[m[32m                        </option>[m
[32m+[m[32m                    </select>[m
[32m+[m[32m                </span>[m
[32m+[m
[32m+[m
[32m+[m
             <div class="snipcart-details top_brand_home_details item_add single-item hvr-outline-out button2">[m
 [m
             <input type="submit" name="submit" value="Ajouter au panier" class="button" (click)="onAdd(id,price,productName,url+images[0].name)" *ngIf="!selected">[m
[1mdiff --git a/src/app/product/product.component.ts b/src/app/product/product.component.ts[m
[1mindex ea16e10..1a71624 100644[m
[1m--- a/src/app/product/product.component.ts[m
[1m+++ b/src/app/product/product.component.ts[m
[36m@@ -7,6 +7,7 @@[m [mimport {Shoping} from '../models/Shoping';[m
 import {Subscription} from 'rxjs/Subscription';[m
 import {Subject} from 'rxjs/Subject';[m
 import {forEach} from '@angular/router/src/utils/collection';[m
[32m+[m[32mimport {FormBuilder, FormGroup, Validators} from '@angular/forms';[m
 [m
 @Component({[m
     providers: [TopNavComponent ],[m
[36m@@ -23,19 +24,21 @@[m [mexport class ProductComponent implements OnInit {[m
     @Input() price: number;[m
     @Input() quantity: number ;[m
     @Input() images = [];[m
[32m+[m[32m    @Input() sizes = [];[m
     public subscription: Subscription;[m
     private val: Subject <any>;[m
     basket ;[m
     selected = false;[m
[32m+[m[32m    itemForm: FormGroup;[m
     url = 'http://localhost:8888/pfe_marketplace/web/uploads/product/';[m
[31m-  constructor(private shoping: ShopingService, private route: Router ) {[m
[32m+[m[32m  constructor(private shoping: ShopingService, private route: Router, private formBuilder: FormBuilder) {[m
       this.basket = this.shoping.getProducts();[m
   }[m
   ngOnInit() {[m
       for (const b of this.basket) {[m
[31m-      if (this.id === b.id) {[m
[31m-          this.selected = true;[m
[31m-      }[m
[32m+[m[32m          if (this.id === b.id) {[m
[32m+[m[32m              this.selected = true;[m
[32m+[m[32m          }[m
       }[m
   }[m
   onAdd(id, price , name, image) {[m
[36m@@ -48,4 +51,10 @@[m [mexport class ProductComponent implements OnInit {[m
         this.selected = false;[m
         this.basket = this.shoping.getProducts();[m
     }[m
[32m+[m[32m    initForm() {[m
[32m+[m[32m        this.itemForm = this.formBuilder.group({[m
[32m+[m[32m            quantity: ['1', [Validators.required]],[m
[32m+[m[32m            size: [ [Validators.required]][m
[32m+[m[32m        });[m
[32m+[m[32m    }[m
 }[m
[1mdiff --git a/src/app/services/shoping.service.ts b/src/app/services/shoping.service.ts[m
[1mindex 9115813..1e5a662 100644[m
[1m--- a/src/app/services/shoping.service.ts[m
[1m+++ b/src/app/services/shoping.service.ts[m
[36m@@ -30,12 +30,12 @@[m [mexport class ShopingService {[m
     public saveItems () {[m
         const items = [] ;[m
         for (const product of this.products) {[m
[31m-            const item = new Item(product.id, product.quantity);[m
[32m+[m[32m            const item = new Item(product.id, product.quantity, product.size);[m
             items.push(item);[m
         }[m
         this.saveToServer( new Order(this.totalPrice, items));[m
     }[m
[31m-    public AddToBasket(id, price, name, image, quantity) {[m
[32m+[m[32m    public AddToBasket(id, price, name, image, quantity, size) {[m
         this.itemCount++;[m
         this.itemCountSource.next(this.itemCount);[m
         this.totalPrice += price * quantity;[m
[36m@@ -45,13 +45,15 @@[m [mexport class ShopingService {[m
             product_name: '',[m
             price: '',[m
             image: '',[m
[31m-            quantity: ''[m
[32m+[m[32m            quantity: '',[m
[32m+[m[32m            size: ''[m
         };[m
         productObject.id = id;[m
         productObject.product_name = name;[m
         productObject.price = price;[m
         productObject.image = image;[m
         productObject.quantity = quantity;[m
[32m+[m[32m        productObject.size = size;[m
         this.products.push(productObject);[m
     }[m
     public getProducts () {[m

[33mcommit 1be1d2b098ceaf4fc15b13945c8815f18754e08b[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Tue May 8 11:19:57 2018 +0100

    delete order service

[1mdiff --git a/src/app/app.module.ts b/src/app/app.module.ts[m
[1mindex eb937d4..8b34667 100644[m
[1m--- a/src/app/app.module.ts[m
[1m+++ b/src/app/app.module.ts[m
[36m@@ -35,7 +35,6 @@[m [mimport { AdressComponent } from './adress/adress.component';[m
 import {AddressService} from './services/address.service';[m
 import { PaymentComponent } from './payment/payment.component';[m
 import { ConfirmationComponent } from './confirmation/confirmation.component';[m
[31m-import {OrderService} from './services/order.service';[m
 [m
 [m
 [m
[36m@@ -123,8 +122,7 @@[m [mconst appRoutes: Routes = [[m
       ShopingService,[m
       CustomerService,[m
       AuthGuard,[m
[31m-      AddressService,[m
[31m-      OrderService[m
[32m+[m[32m      AddressService[m
   ],[m
   bootstrap: [AppComponent][m
 })[m
[1mdiff --git a/src/app/confirmation/confirmation.component.ts b/src/app/confirmation/confirmation.component.ts[m
[1mindex e3f2ea9..ace0647 100644[m
[1m--- a/src/app/confirmation/confirmation.component.ts[m
[1m+++ b/src/app/confirmation/confirmation.component.ts[m
[36m@@ -1,7 +1,5 @@[m
 import { Component, OnInit } from '@angular/core';[m
 import {ShopingService} from '../services/shoping.service';[m
[31m-import {OrderService} from '../services/order.service';[m
[31m-import {Order} from '../models/Order.model';[m
 [m
 @Component({[m
   selector: 'app-confirmation',[m
[36m@@ -10,7 +8,7 @@[m [mimport {Order} from '../models/Order.model';[m
 })[m
 export class ConfirmationComponent implements OnInit {[m
   pay = true;[m
[31m-  constructor(private shopingService: ShopingService, private orderService: OrderService) { }[m
[32m+[m[32m  constructor(private shopingService: ShopingService) { }[m
 [m
   ngOnInit() {[m
     this.shopingService.saveItems();[m
[1mdiff --git a/src/app/services/order.service.ts b/src/app/services/order.service.ts[m
[1mdeleted file mode 100644[m
[1mindex 18aff72..0000000[m
[1m--- a/src/app/services/order.service.ts[m
[1m+++ /dev/null[m
[36m@@ -1,42 +0,0 @@[m
[31m-import { Injectable } from '@angular/core';[m
[31m-import {Subject} from 'rxjs/Subject';[m
[31m-import {HttpClient} from '@angular/common/http';[m
[31m-import {Order} from '../models/Order.model';[m
[31m-[m
[31m-@Injectable()[m
[31m-export class OrderService {[m
[31m-    orderSubject = new Subject<any[]>();[m
[31m-    private orders = [] ;[m
[31m-    constructor(private httpClient: HttpClient) { }[m
[31m-    public emitOrderSubject() {[m
[31m-        this.orderSubject.next(this.orders.slice());[m
[31m-    }[m
[31m-    public getOrdersFromServer () {[m
[31m-        const customerId = localStorage.getItem('id');[m
[31m-        this.httpClient.get<any[]>('http://localhost:8888/pfe_marketplace/web/app_dev.php/api/orders/' + customerId).subscribe([m
[31m-            (response) => {this.orders = response;[m
[31m-                this.emitOrderSubject();[m
[31m-            },[m
[31m-            (error) => {console.log('Erreur ! :' + error); }[m
[31m-        );[m
[31m-    }[m
[31m-    saveOrderToServer(body: any) {[m
[31m-        const customerId = localStorage.getItem('id');[m
[31m-        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/orders/' + customerId;[m
[31m-        const b = JSON.stringify(body);[m
[31m-        this.httpClient.post(url, b, {[m
[31m-            headers: {'Content-Type': 'application/json'}[m
[31m-        })[m
[31m-            .subscribe([m
[31m-                () => {}, (error) => {console.log( b + 'erreur' + error); }[m
[31m-            );[m
[31m-    }[m
[31m-    addOrder(order: Order) {[m
[31m-        this.orders.push(order);[m
[31m-        this.emitOrderSubject();[m
[31m-        this.saveOrderToServer(order);[m
[31m-    }[m
[31m-    getOrders() {[m
[31m-        return this.orders[0].id;[m
[31m-    }[m
[31m-}[m

[33mcommit 37bdcc0020fedfa8f48004a5b851759c5df08fdd[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Tue May 8 11:16:33 2018 +0100

    fix address validators

[1mdiff --git a/src/app/adress/adress.component.html b/src/app/adress/adress.component.html[m
[1mindex 33f0b64..163a21c 100644[m
[1m--- a/src/app/adress/adress.component.html[m
[1m+++ b/src/app/adress/adress.component.html[m
[36m@@ -55,8 +55,6 @@[m
 [m
 [m
 [m
[31m-[m
[31m-[m
                         <div class="styled-input">[m
                             <input type="text" id="address" placeholder="Rue, numéro, étage,..." formControlName="address">[m
                             <label  for="address">Adresse* :</label>[m
[36m@@ -82,7 +80,7 @@[m
                         <br>[m
                         <br><br>[m
                         <div class="styled-input">[m
[31m-                        <select class="form-control" >[m
[32m+[m[32m                        <select class="form-control" formControlName="country">[m
                             <option>France</option>[m
                         </select>[m
                         </div>[m
[36m@@ -94,7 +92,7 @@[m
                            <p> (*Champs obligatoires)</p>[m
                         <br>[m
                         <div  style="float: right;">[m
[31m-                            <input type="submit" value="Valider cette adresse" >[m
[32m+[m[32m                            <input type="submit" value="Valider cette adresse" [disabled]="addressForm.invalid">[m
                         </div>[m
                     </form>[m
                 </div>[m
[1mdiff --git a/src/app/adress/adress.component.ts b/src/app/adress/adress.component.ts[m
[1mindex 8bd1f6d..859da18 100644[m
[1m--- a/src/app/adress/adress.component.ts[m
[1m+++ b/src/app/adress/adress.component.ts[m
[36m@@ -1,5 +1,5 @@[m
 import { Component, OnInit } from '@angular/core';[m
[31m-import {FormBuilder, FormGroup} from '@angular/forms';[m
[32m+[m[32mimport {FormBuilder, FormGroup, Validators} from '@angular/forms';[m
 import {Address} from '../models/Address.model';[m
 import {AddressService} from '../services/address.service';[m
 import {Router} from '@angular/router';[m
[36m@@ -24,11 +24,11 @@[m [mexport class AdressComponent implements OnInit {[m
             customerName: name,[m
             familyName: familyName,[m
             phoneNumber: phoneNumber,[m
[31m-            country: '',[m
[31m-            city: '',[m
[31m-            address: '',[m
[31m-            name: '',[m
[31m-            postal_code: ''[m
[32m+[m[32m            country: ['', Validators.required],[m
[32m+[m[32m            city: ['', Validators.required],[m
[32m+[m[32m            address: ['', Validators.required],[m
[32m+[m[32m            name: ['', Validators.required],[m
[32m+[m[32m            postal_code: ['', Validators.required],[m
         });[m
     }[m
     onSubmitForm() {[m
[1mdiff --git a/src/app/confirmation/confirmation.component.ts b/src/app/confirmation/confirmation.component.ts[m
[1mindex c1d10ba..e3f2ea9 100644[m
[1m--- a/src/app/confirmation/confirmation.component.ts[m
[1m+++ b/src/app/confirmation/confirmation.component.ts[m
[36m@@ -13,8 +13,6 @@[m [mexport class ConfirmationComponent implements OnInit {[m
   constructor(private shopingService: ShopingService, private orderService: OrderService) { }[m
 [m
   ngOnInit() {[m
[31m-      const order = new Order(this.shopingService.totalPrice);[m
[31m-      this.orderService.addOrder(order);[m
     this.shopingService.saveItems();[m
   }[m
 [m
[1mdiff --git a/src/app/models/Item.model.ts b/src/app/models/Item.model.ts[m
[1mindex 2718529..0989c3c 100644[m
[1m--- a/src/app/models/Item.model.ts[m
[1m+++ b/src/app/models/Item.model.ts[m
[36m@@ -1,3 +1,4 @@[m
[32m+[m
 export class Item {[m
     constructor([m
         public product: string,[m
[1mdiff --git a/src/app/models/Order.model.ts b/src/app/models/Order.model.ts[m
[1mindex 2dd9cd5..b36d58d 100644[m
[1m--- a/src/app/models/Order.model.ts[m
[1m+++ b/src/app/models/Order.model.ts[m
[36m@@ -1,5 +1,8 @@[m
[32m+[m[32mimport {Item} from './Item.model';[m
[32m+[m
 export class Order {[m
     constructor([m
         public amount: number,[m
[32m+[m[32m        public items: Item [][m
     ) {}[m
 }[m
[1mdiff --git a/src/app/services/order.service.ts b/src/app/services/order.service.ts[m
[1mindex ea923bb..18aff72 100644[m
[1m--- a/src/app/services/order.service.ts[m
[1m+++ b/src/app/services/order.service.ts[m
[36m@@ -1,7 +1,6 @@[m
 import { Injectable } from '@angular/core';[m
 import {Subject} from 'rxjs/Subject';[m
 import {HttpClient} from '@angular/common/http';[m
[31m-import {Customer} from '../models/Customer.model';[m
 import {Order} from '../models/Order.model';[m
 [m
 @Injectable()[m
[36m@@ -12,9 +11,17 @@[m [mexport class OrderService {[m
     public emitOrderSubject() {[m
         this.orderSubject.next(this.orders.slice());[m
     }[m
[32m+[m[32m    public getOrdersFromServer () {[m
[32m+[m[32m        const customerId = localStorage.getItem('id');[m
[32m+[m[32m        this.httpClient.get<any[]>('http://localhost:8888/pfe_marketplace/web/app_dev.php/api/orders/' + customerId).subscribe([m
[32m+[m[32m            (response) => {this.orders = response;[m
[32m+[m[32m                this.emitOrderSubject();[m
[32m+[m[32m            },[m
[32m+[m[32m            (error) => {console.log('Erreur ! :' + error); }[m
[32m+[m[32m        );[m
[32m+[m[32m    }[m
     saveOrderToServer(body: any) {[m
         const customerId = localStorage.getItem('id');[m
[31m-        console.log('id customer' + customerId);[m
         const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/orders/' + customerId;[m
         const b = JSON.stringify(body);[m
         this.httpClient.post(url, b, {[m
[36m@@ -29,4 +36,7 @@[m [mexport class OrderService {[m
         this.emitOrderSubject();[m
         this.saveOrderToServer(order);[m
     }[m
[32m+[m[32m    getOrders() {[m
[32m+[m[32m        return this.orders[0].id;[m
[32m+[m[32m    }[m
 }[m
[1mdiff --git a/src/app/services/shoping.service.ts b/src/app/services/shoping.service.ts[m
[1mindex 8dd7f4a..9115813 100644[m
[1m--- a/src/app/services/shoping.service.ts[m
[1m+++ b/src/app/services/shoping.service.ts[m
[36m@@ -1,8 +1,8 @@[m
 import { Injectable } from '@angular/core';[m
 import {BehaviorSubject} from 'rxjs/BehaviorSubject';[m
 import {HttpClient} from '@angular/common/http';[m
[31m-import {Address} from '../models/Address.model';[m
 import {Item} from '../models/Item.model';[m
[32m+[m[32mimport {Order} from '../models/Order.model';[m
 [m
 @Injectable()[m
 export class ShopingService {[m
[36m@@ -17,8 +17,8 @@[m [mexport class ShopingService {[m
         this.totalPrice = 0.0;[m
     }[m
     saveToServer(body: any) {[m
[31m-        /*const customerId = localStorage.getItem('id');*/[m
[31m-        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/items';[m
[32m+[m[32m        const customerId = localStorage.getItem('id');[m
[32m+[m[32m        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/orders/' + customerId;[m
         const b = JSON.stringify(body);[m
         this.httpClient.post(url, b, {[m
             headers: {'Content-Type': 'application/json'}[m
[36m@@ -28,10 +28,12 @@[m [mexport class ShopingService {[m
             );[m
     }[m
     public saveItems () {[m
[32m+[m[32m        const items = [] ;[m
         for (const product of this.products) {[m
             const item = new Item(product.id, product.quantity);[m
[31m-            this.saveToServer(item);[m
[32m+[m[32m            items.push(item);[m
         }[m
[32m+[m[32m        this.saveToServer( new Order(this.totalPrice, items));[m
     }[m
     public AddToBasket(id, price, name, image, quantity) {[m
         this.itemCount++;[m

[33mcommit 921ff69f23dcbedcfb930a2888b149dbea5d8613[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Sat May 5 22:11:10 2018 +0100

    update order

[1mdiff --git a/src/app/adress/adress.component.ts b/src/app/adress/adress.component.ts[m
[1mindex 83a96f4..8bd1f6d 100644[m
[1m--- a/src/app/adress/adress.component.ts[m
[1m+++ b/src/app/adress/adress.component.ts[m
[36m@@ -2,6 +2,7 @@[m [mimport { Component, OnInit } from '@angular/core';[m
 import {FormBuilder, FormGroup} from '@angular/forms';[m
 import {Address} from '../models/Address.model';[m
 import {AddressService} from '../services/address.service';[m
[32m+[m[32mimport {Router} from '@angular/router';[m
 [m
 @Component({[m
   selector: 'app-adress',[m
[36m@@ -10,7 +11,7 @@[m [mimport {AddressService} from '../services/address.service';[m
 })[m
 export class AdressComponent implements OnInit {[m
     addressForm: FormGroup;[m
[31m-  constructor(private formBuilder: FormBuilder, private addressService: AddressService) { }[m
[32m+[m[32m  constructor(private formBuilder: FormBuilder, private addressService: AddressService, private router: Router ) { }[m
 [m
   ngOnInit() {[m
       this.initForm();[m
[36m@@ -41,7 +42,7 @@[m [mexport class AdressComponent implements OnInit {[m
             formValue['postal_code'][m
         );[m
         this.addressService.add(address) ;[m
[31m-        /* this.router.navigate(['']);*/[m
[32m+[m[32m         this.router.navigate(['payment']);[m
     }[m
 [m
 }[m
[1mdiff --git a/src/app/app.module.ts b/src/app/app.module.ts[m
[1mindex 17ac769..eb937d4 100644[m
[1m--- a/src/app/app.module.ts[m
[1m+++ b/src/app/app.module.ts[m
[36m@@ -33,6 +33,9 @@[m [mimport { CustomerProfileComponent } from './customer-profile/customer-profile.co[m
 import { JewelryComponent } from './jewelry/jewelry.component';[m
 import { AdressComponent } from './adress/adress.component';[m
 import {AddressService} from './services/address.service';[m
[32m+[m[32mimport { PaymentComponent } from './payment/payment.component';[m
[32m+[m[32mimport { ConfirmationComponent } from './confirmation/confirmation.component';[m
[32m+[m[32mimport {OrderService} from './services/order.service';[m
 [m
 [m
 [m
[36m@@ -44,6 +47,8 @@[m [mconst appRoutes: Routes = [[m
     /*basket-list*/[m
     { path: 'basket', component: BasketListComponent},[m
     { path: 'address', component: AdressComponent},[m
[32m+[m[32m    { path: 'payment', component: PaymentComponent},[m
[32m+[m[32m    { path: 'confirmation', component: ConfirmationComponent},[m
     { path: 'clothes',  component: ClothesComponent},[m
     { path: 'beauty',  component: BeautyComponent},[m
     { path: 'HighTec',  component: HighTecComponent},[m
[36m@@ -103,6 +108,8 @@[m [mconst appRoutes: Routes = [[m
     CustomerProfileComponent,[m
     JewelryComponent,[m
     AdressComponent,[m
[32m+[m[32m    PaymentComponent,[m
[32m+[m[32m    ConfirmationComponent,[m
   ],[m
   imports: [[m
     BrowserModule,[m
[36m@@ -117,6 +124,7 @@[m [mconst appRoutes: Routes = [[m
       CustomerService,[m
       AuthGuard,[m
       AddressService,[m
[32m+[m[32m      OrderService[m
   ],[m
   bootstrap: [AppComponent][m
 })[m
[1mdiff --git a/src/app/confirmation/confirmation.component.html b/src/app/confirmation/confirmation.component.html[m
[1mnew file mode 100644[m
[1mindex 0000000..9e57bd8[m
[1m--- /dev/null[m
[1m+++ b/src/app/confirmation/confirmation.component.html[m
[36m@@ -0,0 +1,32 @@[m
[32m+[m[32m<!--breadcrump start-->[m
[32m+[m[32m<div class="row bs-wizard" style="border-bottom:0;">[m
[32m+[m
[32m+[m[32m  <div class="col-xs-3 bs-wizard-step complete">[m
[32m+[m[32m    <div class="text-center bs-wizard-stepnum">Mon panier</div>[m
[32m+[m[32m    <div class="progress"><div class="progress-bar"></div></div>[m
[32m+[m[32m    <a  class="bs-wizard-dot"></a>[m
[32m+[m
[32m+[m[32m  </div>[m
[32m+[m
[32m+[m[32m  <div class="col-xs-3 bs-wizard-step complete"><!-- complete -->[m
[32m+[m[32m    <div class="text-center bs-wizard-stepnum">Livraison</div>[m
[32m+[m[32m    <div class="progress"><div class="progress-bar"></div></div>[m
[32m+[m[32m    <a href="#" class="bs-wizard-dot"></a>[m
[32m+[m[32m  </div>[m
[32m+[m
[32m+[m[32m  <div class="col-xs-3 bs-wizard-step complete"><!-- complete -->[m
[32m+[m[32m    <div class="text-center bs-wizard-stepnum">Paiement</div>[m
[32m+[m[32m    <div class="progress"><div class="progress-bar"></div></div>[m
[32m+[m[32m    <a href="#" class="bs-wizard-dot"></a>[m
[32m+[m[32m  </div>[m
[32m+[m
[32m+[m[32m  <div class="col-xs-3 bs-wizard-step active"><!-- active -->[m
[32m+[m[32m    <div class="text-center bs-wizard-stepnum">Confirmation</div>[m
[32m+[m[32m    <div class="progress"><div class="progress-bar"></div></div>[m
[32m+[m[32m    <a href="#" class="bs-wizard-dot"></a>[m
[32m+[m[32m  </div>[m
[32m+[m[32m</div>[m
[32m+[m[32m<!--breadcrump end-->[m
[32m+[m
[32m+[m
[32m+[m
[1mdiff --git a/src/app/confirmation/confirmation.component.scss b/src/app/confirmation/confirmation.component.scss[m
[1mnew file mode 100644[m
[1mindex 0000000..9d3093c[m
[1m--- /dev/null[m
[1m+++ b/src/app/confirmation/confirmation.component.scss[m
[36m@@ -0,0 +1,27 @@[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m[32m/*breadcrump*/[m
[32m+[m[32m.bs-wizard {margin-top: 40px;}[m
[32m+[m
[32m+[m[32m/*Form Wizard*/[m
[32m+[m[32m.bs-wizard {border-bottom: solid 1px #e0e0e0; padding: 0 0 10px 0;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step {padding: 0; position: relative;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step + .bs-wizard-step {}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step .bs-wizard-stepnum {color: #595959; font-size: 16px; margin-bottom: 5px;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step .bs-wizard-info {color: #999; font-size: 14px;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step > .bs-wizard-dot {position: absolute; width: 30px; height: 30px; display: block; background: #fbe8aa; top: 45px; left: 50%; margin-top: -15px; margin-left: -15px; border-radius: 50%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step > .bs-wizard-dot:after {content: ' '; width: 14px; height: 14px; background: #fbbd19; border-radius: 50px; position: absolute; top: 8px; left: 8px; }[m
[32m+[m[32m.bs-wizard > .bs-wizard-step > .progress {position: relative; border-radius: 0px; height: 8px; box-shadow: none; margin: 20px 0;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step > .progress > .progress-bar {width:0px; box-shadow: none; background: #fbe8aa;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.complete > .progress > .progress-bar {width:100%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.active > .progress > .progress-bar {width:50%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step:first-child.active > .progress > .progress-bar {width:0%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step:last-child.active > .progress > .progress-bar {width: 100%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.disabled > .bs-wizard-dot {background-color: #f5f5f5;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.disabled > .bs-wizard-dot:after {opacity: 0;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step:first-child  > .progress {left: 50%; width: 50%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step:last-child  > .progress {width: 50%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.disabled a.bs-wizard-dot{ pointer-events: none; }[m
\ No newline at end of file[m
[1mdiff --git a/src/app/confirmation/confirmation.component.ts b/src/app/confirmation/confirmation.component.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..c1d10ba[m
[1m--- /dev/null[m
[1m+++ b/src/app/confirmation/confirmation.component.ts[m
[36m@@ -0,0 +1,21 @@[m
[32m+[m[32mimport { Component, OnInit } from '@angular/core';[m
[32m+[m[32mimport {ShopingService} from '../services/shoping.service';[m
[32m+[m[32mimport {OrderService} from '../services/order.service';[m
[32m+[m[32mimport {Order} from '../models/Order.model';[m
[32m+[m
[32m+[m[32m@Component({[m
[32m+[m[32m  selector: 'app-confirmation',[m
[32m+[m[32m  templateUrl: './confirmation.component.html',[m
[32m+[m[32m  styleUrls: ['./confirmation.component.scss'][m
[32m+[m[32m})[m
[32m+[m[32mexport class ConfirmationComponent implements OnInit {[m
[32m+[m[32m  pay = true;[m
[32m+[m[32m  constructor(private shopingService: ShopingService, private orderService: OrderService) { }[m
[32m+[m
[32m+[m[32m  ngOnInit() {[m
[32m+[m[32m      const order = new Order(this.shopingService.totalPrice);[m
[32m+[m[32m      this.orderService.addOrder(order);[m
[32m+[m[32m    this.shopingService.saveItems();[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m}[m
[1mdiff --git a/src/app/models/Item.model.ts b/src/app/models/Item.model.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..2718529[m
[1m--- /dev/null[m
[1m+++ b/src/app/models/Item.model.ts[m
[36m@@ -0,0 +1,6 @@[m
[32m+[m[32mexport class Item {[m
[32m+[m[32m    constructor([m
[32m+[m[32m        public product: string,[m
[32m+[m[32m        public quantity: string,[m
[32m+[m[32m    ) {}[m
[32m+[m[32m}[m
[1mdiff --git a/src/app/models/Order.model.ts b/src/app/models/Order.model.ts[m
[1mindex 078dcb3..2dd9cd5 100644[m
[1m--- a/src/app/models/Order.model.ts[m
[1m+++ b/src/app/models/Order.model.ts[m
[36m@@ -1,5 +1,5 @@[m
 export class Order {[m
     constructor([m
[31m-        public name: string[m
[32m+[m[32m        public amount: number,[m
     ) {}[m
 }[m
[1mdiff --git a/src/app/payment/payment.component.html b/src/app/payment/payment.component.html[m
[1mnew file mode 100644[m
[1mindex 0000000..4fd55e6[m
[1m--- /dev/null[m
[1m+++ b/src/app/payment/payment.component.html[m
[36m@@ -0,0 +1,41 @@[m
[32m+[m[32m<!--breadcrump start-->[m
[32m+[m[32m<div class="row bs-wizard" style="border-bottom:0;">[m
[32m+[m
[32m+[m[32m    <div class="col-xs-3 bs-wizard-step complete">[m
[32m+[m[32m        <div class="text-center bs-wizard-stepnum">Mon panier</div>[m
[32m+[m[32m        <div class="progress"><div class="progress-bar"></div></div>[m
[32m+[m[32m        <a  class="bs-wizard-dot"></a>[m
[32m+[m
[32m+[m[32m    </div>[m
[32m+[m
[32m+[m[32m    <div class="col-xs-3 bs-wizard-step complete"><!-- complete -->[m
[32m+[m[32m        <div class="text-center bs-wizard-stepnum">Livraison</div>[m
[32m+[m[32m        <div class="progress"><div class="progress-bar"></div></div>[m
[32m+[m[32m        <a href="#" class="bs-wizard-dot"></a>[m
[32m+[m[32m    </div>[m
[32m+[m
[32m+[m[32m    <div class="col-xs-3 bs-wizard-step active"><!-- complete -->[m
[32m+[m[32m        <div class="text-center bs-wizard-stepnum">Paiement</div>[m
[32m+[m[32m        <div class="progress"><div class="progress-bar"></div></div>[m
[32m+[m[32m        <a href="#" class="bs-wizard-dot"></a>[m
[32m+[m[32m    </div>[m
[32m+[m
[32m+[m[32m    <div class="col-xs-3 bs-wizard-step disabled"><!-- active -->[m
[32m+[m[32m        <div class="text-center bs-wizard-stepnum">Confirmation</div>[m
[32m+[m[32m        <div class="progress"><div class="progress-bar"></div></div>[m
[32m+[m[32m        <a href="#" class="bs-wizard-dot"></a>[m
[32m+[m[32m    </div>[m
[32m+[m[32m</div>[m
[32m+[m[32m<!--breadcrump end-->[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m[32m<a routerLink="/confirmation">payer</a>[m
\ No newline at end of file[m
[1mdiff --git a/src/app/payment/payment.component.scss b/src/app/payment/payment.component.scss[m
[1mnew file mode 100644[m
[1mindex 0000000..9b150dd[m
[1m--- /dev/null[m
[1m+++ b/src/app/payment/payment.component.scss[m
[36m@@ -0,0 +1,22 @@[m
[32m+[m[32m/*breadcrump*/[m
[32m+[m[32m.bs-wizard {margin-top: 40px;}[m
[32m+[m
[32m+[m[32m/*Form Wizard*/[m
[32m+[m[32m.bs-wizard {border-bottom: solid 1px #e0e0e0; padding: 0 0 10px 0;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step {padding: 0; position: relative;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step + .bs-wizard-step {}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step .bs-wizard-stepnum {color: #595959; font-size: 16px; margin-bottom: 5px;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step .bs-wizard-info {color: #999; font-size: 14px;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step > .bs-wizard-dot {position: absolute; width: 30px; height: 30px; display: block; background: #fbe8aa; top: 45px; left: 50%; margin-top: -15px; margin-left: -15px; border-radius: 50%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step > .bs-wizard-dot:after {content: ' '; width: 14px; height: 14px; background: #fbbd19; border-radius: 50px; position: absolute; top: 8px; left: 8px; }[m
[32m+[m[32m.bs-wizard > .bs-wizard-step > .progress {position: relative; border-radius: 0px; height: 8px; box-shadow: none; margin: 20px 0;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step > .progress > .progress-bar {width:0px; box-shadow: none; background: #fbe8aa;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.complete > .progress > .progress-bar {width:100%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.active > .progress > .progress-bar {width:50%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step:first-child.active > .progress > .progress-bar {width:0%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step:last-child.active > .progress > .progress-bar {width: 100%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.disabled > .bs-wizard-dot {background-color: #f5f5f5;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.disabled > .bs-wizard-dot:after {opacity: 0;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step:first-child  > .progress {left: 50%; width: 50%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step:last-child  > .progress {width: 50%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.disabled a.bs-wizard-dot{ pointer-events: none; }[m
\ No newline at end of file[m
[1mdiff --git a/src/app/payment/payment.component.ts b/src/app/payment/payment.component.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..dd744e6[m
[1m--- /dev/null[m
[1m+++ b/src/app/payment/payment.component.ts[m
[36m@@ -0,0 +1,15 @@[m
[32m+[m[32mimport { Component, OnInit } from '@angular/core';[m
[32m+[m
[32m+[m[32m@Component({[m
[32m+[m[32m  selector: 'app-payment',[m
[32m+[m[32m  templateUrl: './payment.component.html',[m
[32m+[m[32m  styleUrls: ['./payment.component.scss'][m
[32m+[m[32m})[m
[32m+[m[32mexport class PaymentComponent implements OnInit {[m
[32m+[m
[32m+[m[32m  constructor() { }[m
[32m+[m
[32m+[m[32m  ngOnInit() {[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m}[m
[1mdiff --git a/src/app/services/address.service.ts b/src/app/services/address.service.ts[m
[1mindex d1672aa..e4bda12 100644[m
[1m--- a/src/app/services/address.service.ts[m
[1m+++ b/src/app/services/address.service.ts[m
[36m@@ -11,14 +11,14 @@[m [mexport class AddressService {[m
     public emitAddressSubject() {[m
         this.addressSubject.next(this.addresses.slice());[m
     }[m
[31m-    public getAddresses() {[m
[32m+[m[32m    /*public getAddresses() {[m
         this.httpClient.get<any[]>('http://localhost:8888/pfe_marketplace/web/app_dev.php/api/customers/addresses').subscribe([m
             (response) => {this.addresses = response;[m
                 this.emitAddressSubject();[m
             },[m
             (error) => {console.log('Erreur ! :' + error); }[m
         );[m
[31m-    }[m
[32m+[m[32m    }*/[m
     saveToServer(body: any) {[m
         const customerId = localStorage.getItem('id');[m
         const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/customers/addresses/' + customerId;[m
[1mdiff --git a/src/app/services/order.service.ts b/src/app/services/order.service.ts[m
[1mindex 2cc585a..ea923bb 100644[m
[1m--- a/src/app/services/order.service.ts[m
[1m+++ b/src/app/services/order.service.ts[m
[36m@@ -13,7 +13,9 @@[m [mexport class OrderService {[m
         this.orderSubject.next(this.orders.slice());[m
     }[m
     saveOrderToServer(body: any) {[m
[31m-        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/orders';[m
[32m+[m[32m        const customerId = localStorage.getItem('id');[m
[32m+[m[32m        console.log('id customer' + customerId);[m
[32m+[m[32m        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/orders/' + customerId;[m
         const b = JSON.stringify(body);[m
         this.httpClient.post(url, b, {[m
             headers: {'Content-Type': 'application/json'}[m
[1mdiff --git a/src/app/services/shoping.service.ts b/src/app/services/shoping.service.ts[m
[1mindex 1d2fd21..8dd7f4a 100644[m
[1m--- a/src/app/services/shoping.service.ts[m
[1m+++ b/src/app/services/shoping.service.ts[m
[36m@@ -1,5 +1,8 @@[m
 import { Injectable } from '@angular/core';[m
 import {BehaviorSubject} from 'rxjs/BehaviorSubject';[m
[32m+[m[32mimport {HttpClient} from '@angular/common/http';[m
[32m+[m[32mimport {Address} from '../models/Address.model';[m
[32m+[m[32mimport {Item} from '../models/Item.model';[m
 [m
 @Injectable()[m
 export class ShopingService {[m
[36m@@ -8,12 +11,28 @@[m [mexport class ShopingService {[m
     itemCount$ = this.itemCountSource.asObservable();[m
     totalPrice: number;[m
     private products = [];[m
[31m-    constructor() {[m
[32m+[m[32m    constructor(private httpClient: HttpClient) {[m
         this.itemCount = 0;[m
         this.itemCountSource.next(0);[m
         this.totalPrice = 0.0;[m
     }[m
[31m-[m
[32m+[m[32m    saveToServer(body: any) {[m
[32m+[m[32m        /*const customerId = localStorage.getItem('id');*/[m
[32m+[m[32m        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/items';[m
[32m+[m[32m        const b = JSON.stringify(body);[m
[32m+[m[32m        this.httpClient.post(url, b, {[m
[32m+[m[32m            headers: {'Content-Type': 'application/json'}[m
[32m+[m[32m        })[m
[32m+[m[32m            .subscribe([m
[32m+[m[32m                () => {}, (error) => {console.log( b + 'erreur' + error); }[m
[32m+[m[32m            );[m
[32m+[m[32m    }[m
[32m+[m[32m    public saveItems () {[m
[32m+[m[32m        for (const product of this.products) {[m
[32m+[m[32m            const item = new Item(product.id, product.quantity);[m
[32m+[m[32m            this.saveToServer(item);[m
[32m+[m[32m        }[m
[32m+[m[32m    }[m
     public AddToBasket(id, price, name, image, quantity) {[m
         this.itemCount++;[m
         this.itemCountSource.next(this.itemCount);[m

[33mcommit 6c71dc76c7e0ab37b91b870e2b5215f95adc2e2b[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Sat May 5 18:19:25 2018 +0100

    create add address

[1mdiff --git a/src/app/adress/adress.component.html b/src/app/adress/adress.component.html[m
[1mindex 139c0fe..33f0b64 100644[m
[1m--- a/src/app/adress/adress.component.html[m
[1m+++ b/src/app/adress/adress.component.html[m
[36m@@ -27,15 +27,18 @@[m
   </div>[m
 </div>[m
 <!--breadcrump end-->[m
[32m+[m
 <div class="banner_bottom_agile_info">[m
     <div class="container">[m
         <div class="agile-contact-grids">[m
             <div class="agile-contact-left">[m
                 <div class="col-md-12 contact-form">[m
                     <h4 class="white-w3ls">CREATION D'UNE ADRESSE DE <span>LIVRAISON</span></h4>[m
[31m-                    <form method="post" action="#">[m
[32m+[m
[32m+[m[32m                    <form [formGroup]="addressForm" (ngSubmit)="onSubmitForm()">[m
[32m+[m
                         <div class="styled-input agile-styled-input-top">[m
[31m-                            <input type="text" id="name" placeholder="Prénom" formControlName="name">[m
[32m+[m[32m                            <input type="text" id="name"  formControlName="customerName">[m
                             <label  for="name">Prénom* :</label>[m
                             <span></span>[m
                         </div>[m
[36m@@ -49,6 +52,11 @@[m
                             <label for="tel">Numéro de télephone* :</label>[m
                             <span></span>[m
                         </div>[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
                         <div class="styled-input">[m
                             <input type="text" id="address" placeholder="Rue, numéro, étage,..." formControlName="address">[m
                             <label  for="address">Adresse* :</label>[m
[36m@@ -57,7 +65,6 @@[m
                         <div class="col-md-6 mb-3">[m
 [m
 [m
[31m-<!--form Start-->[m
 [m
                             <div class="styled-input">[m
                                 <input type="text" id="city" placeholder="Ville" formControlName="city">[m
[36m@@ -67,7 +74,7 @@[m
                         </div>[m
                         <div class="col-md-6 mb-3">[m
                             <div class="styled-input">[m
[31m-                                <input type="text" id="postalcode" placeholder="Code postal" formControlName="postalcode">[m
[32m+[m[32m                                <input type="text" id="postalcode" placeholder="Code postal" formControlName="postal_code">[m
                                 <label  for="postalcode">Code postal* :</label>[m
                                 <span></span>[m
                             </div>[m
[1mdiff --git a/src/app/adress/adress.component.ts b/src/app/adress/adress.component.ts[m
[1mindex 42d03df..83a96f4 100644[m
[1m--- a/src/app/adress/adress.component.ts[m
[1m+++ b/src/app/adress/adress.component.ts[m
[36m@@ -31,6 +31,7 @@[m [mexport class AdressComponent implements OnInit {[m
         });[m
     }[m
     onSubmitForm() {[m
[32m+[m[32m        const customerId = localStorage.getItem('id');[m
         const formValue = this.addressForm.value;[m
         const address = new Address([m
             formValue['country'],[m
[1mdiff --git a/src/app/services/address.service.ts b/src/app/services/address.service.ts[m
[1mindex f7cb10d..d1672aa 100644[m
[1m--- a/src/app/services/address.service.ts[m
[1m+++ b/src/app/services/address.service.ts[m
[36m@@ -20,7 +20,8 @@[m [mexport class AddressService {[m
         );[m
     }[m
     saveToServer(body: any) {[m
[31m-        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/customers/addresses';[m
[32m+[m[32m        const customerId = localStorage.getItem('id');[m
[32m+[m[32m        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/customers/addresses/' + customerId;[m
         const b = JSON.stringify(body);[m
         this.httpClient.post(url, b, {[m
             headers: {'Content-Type': 'application/json'}[m

[33mcommit 926087651ff39e3f3014eea3ef402e1bae0c03c5[m
Merge: e4090ed 6fade9f
Author: pophamdi <pophamdi@gmail.com>
Date:   Sat May 5 17:19:04 2018 +0100

    fix commit merge

[33mcommit 6fade9f058d0a08eeb8a1004b6a86357b12776bd[m
Author: Nouha <nouha.bensalem1992@gmail.com>
Date:   Sat May 5 17:14:39 2018 +0100

    update the adress delevery style

[1mdiff --git a/src/app/adress/adress.component.html b/src/app/adress/adress.component.html[m
[1mindex 78ce0de..954fc00 100644[m
[1m--- a/src/app/adress/adress.component.html[m
[1m+++ b/src/app/adress/adress.component.html[m
[36m@@ -27,115 +27,20 @@[m
   </div>[m
 </div>[m
 <!--breadcrump end-->[m
[31m-[m
[31m-<!--form Start[m
[31m-[m
[31m-<div class="content">[m
[31m-    <form method="post" action="#" class="forms">[m
[31m-        <div class="row">[m
[31m-            <h2>CREATION D'UNE ADRESSE DE LIVRAISON</h2>[m
[31m-            <br>[m
[31m-            <h3>Informations</h3>[m
[31m-            <div class="col _s12 _m6">[m
[31m-                <label>Prénom* :[m
[31m-                    <input class="input_1" type="text" name="f-name" placeholder="" required>[m
[31m-                    <span class="grey-line"></span>[m
[31m-                    <span class="blue-line"></span>[m
[31m-                </label>[m
[31m-            </div>[m
[31m-            <div class="col _s12 _m6">[m
[31m-                <label>Nom* :[m
[31m-                    <input class="input_1" type="text" name="f-name" placeholder="" required>[m
[31m-                    <span class="grey-line"></span>[m
[31m-                    <span class="blue-line"></span>[m
[31m-                </label>[m
[31m-            </div>[m
[31m-            <div class="col _s12 _m12">[m
[31m-                <label>Télephone* :[m
[31m-                    <input class="input_1" type="number" name="f-email" placeholder="">[m
[31m-                    <span class="grey-line"></span>[m
[31m-                    <span class="blue-line"></span>[m
[31m-                </label>[m
[31m-            </div>[m
[31m-        </div>[m
[31m-        <div class="row">[m
[31m-            <h3>Adresse de livraison</h3>[m
[31m-            <div class="col _s12 _m12">[m
[31m-                <label>Donner un nom à cette adresse* :[m
[31m-                    <input class="input_1" type="text" name="f-email" placeholder="Bureau, maison ...">[m
[31m-                    <span class="grey-line"></span>[m
[31m-                    <span class="blue-line"></span>[m
[31m-                </label>[m
[31m-            </div>[m
[31m-            <div class="col _s12 _m12">[m
[31m-                <label>Adresse* :[m
[31m-                    <input class="input_1" type="text" name="f-email" placeholder="Rue, numéro, étage,...">[m
[31m-                    <span class="grey-line"></span>[m
[31m-                    <span class="blue-line"></span>[m
[31m-                </label>[m
[31m-[m
[31m-            </div>[m
[31m-            <div class="col _s12 _m6">[m
[31m-                <label>Code postal* :[m
[31m-                    <input class="input_1" type="text" name="f-email" placeholder="Code postal">[m
[31m-                    <span class="grey-line"></span>[m
[31m-                    <span class="blue-line"></span>[m
[31m-                </label>[m
[31m-            </div>[m
[31m-            <div class="col _s12 _m6">[m
[31m-                <label>Ville* :[m
[31m-                    <input class="input_1" type="text" name="f-email" placeholder="Ville">[m
[31m-                    <span class="grey-line"></span>[m
[31m-                    <span class="blue-line"></span>[m
[31m-[m
[31m-                </label>[m
[31m-            </div>[m
[31m-[m
[31m-            <div class="col _s12 _m12">[m
[31m-                <label>Pays* :[m
[31m-                    <SELECT name="nom" size="1">[m
[31m-                        <OPTION>France[m
[31m-                    </SELECT>[m
[31m-                </label>[m
[31m-            </div>[m
[31m-        </div>[m
[31m-[m
[31m-        <div class="row">[m
[31m-            <div class="r-field col _s12 _m12">[m
[31m-                <p>* Champs obligatoires</p>[m
[31m-            </div>[m
[31m-        </div>[m
[31m-[m
[31m-        <div class="row">[m
[31m-            <div class="col-md-offset-8">[m
[31m-                <a href="#" class="button">Valider cette adresse</a>[m
[31m-            </div>[m
[31m-        </div>[m
[31m-    </form>[m
[31m-</div>[m
[31m-[m
[31m--->[m
[31m-[m
[31m-[m
 <div class="banner_bottom_agile_info">[m
     <div class="container">[m
         <div class="agile-contact-grids">[m
             <div class="agile-contact-left">[m
[31m-[m
[31m-[m
[31m-[m
                 <div class="col-md-12 contact-form">[m
                     <h4 class="white-w3ls">CREATION D'UNE ADRESSE DE <span>LIVRAISON</span></h4>[m
[31m-                    <form  [formGroup]="addressForm" (ngSubmit)="onSubmitForm()">[m
[32m+[m[32m                    <form method="post" action="#">[m
                         <div class="styled-input agile-styled-input-top">[m
                             <input type="text" id="name" placeholder="Prénom" formControlName="name">[m
[31m-                            <p class="error_message" *ngIf="customerForm.get('name').invalid">Veuillez fournir au moins 3 caractères.</p>[m
                             <label  for="name">Prénom* :</label>[m
                             <span></span>[m
                         </div>[m
                         <div class="styled-input">[m
                             <input type="text" id="family-name" placeholder="Nom" formControlName="familyName">[m
[31m-                            <p class="error_message" *ngIf="customerForm.get('familyName').invalid">Veuillez fournir au moins 3 caractères.</p>[m
                             <label for="family-name">Nom* :</label>[m
                             <span></span>[m
                         </div>[m
[36m@@ -149,8 +54,6 @@[m
                             <label  for="address">Adresse* :</label>[m
                             <span></span>[m
                         </div>[m
[31m-[m
[31m-[m
                         <div class="col-md-6 mb-3">[m
 [m
                             <div class="styled-input">[m
[36m@@ -159,7 +62,6 @@[m
                                 <span></span>[m
                             </div>[m
                         </div>[m
[31m-[m
                         <div class="col-md-6 mb-3">[m
                             <div class="styled-input">[m
                                 <input type="text" id="postalcode" placeholder="Code postal" formControlName="postalcode">[m
[36m@@ -169,7 +71,6 @@[m
                         </div>[m
                         <br>[m
                         <br><br>[m
[31m-[m
                         <div class="styled-input">[m
                         <select class="form-control" >[m
                             <option>France</option>[m
[36m@@ -183,7 +84,7 @@[m
                            <p> (*Champs obligatoires)</p>[m
                         <br>[m
                         <div  style="float: right;">[m
[31m-                            <input type="submit" value="Valider cette adresse" [disabled]="customerForm.invalid">[m
[32m+[m[32m                            <input type="submit" value="Valider cette adresse" >[m
                         </div>[m
                     </form>[m
                 </div>[m

[33mcommit e4090ed067df2df0dd970476e463730e6eba35f8[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Sat May 5 17:13:17 2018 +0100

    create address service

[1mdiff --git a/src/app/adress/adress.component.html b/src/app/adress/adress.component.html[m
[1mindex f929c8c..bdaebcf 100644[m
[1m--- a/src/app/adress/adress.component.html[m
[1m+++ b/src/app/adress/adress.component.html[m
[36m@@ -38,7 +38,7 @@[m
             <h3>Informations</h3>[m
             <div class="col _s12 _m6">[m
                 <label>Prénom* :[m
[31m-                    <input class="input_1" type="text" name="f-name" placeholder="" required>[m
[32m+[m[32m                    <input class="input_1" type="text" name="f-name" placeholder="" >[m
                     <span class="grey-line"></span>[m
                     <span class="blue-line"></span>[m
                 </label>[m
[1mdiff --git a/src/app/adress/adress.component.ts b/src/app/adress/adress.component.ts[m
[1mindex fc431ec..42d03df 100644[m
[1m--- a/src/app/adress/adress.component.ts[m
[1m+++ b/src/app/adress/adress.component.ts[m
[36m@@ -1,4 +1,7 @@[m
 import { Component, OnInit } from '@angular/core';[m
[32m+[m[32mimport {FormBuilder, FormGroup} from '@angular/forms';[m
[32m+[m[32mimport {Address} from '../models/Address.model';[m
[32m+[m[32mimport {AddressService} from '../services/address.service';[m
 [m
 @Component({[m
   selector: 'app-adress',[m
[36m@@ -6,10 +9,38 @@[m [mimport { Component, OnInit } from '@angular/core';[m
   styleUrls: ['./adress.component.scss'][m
 })[m
 export class AdressComponent implements OnInit {[m
[31m-[m
[31m-  constructor() { }[m
[32m+[m[32m    addressForm: FormGroup;[m
[32m+[m[32m  constructor(private formBuilder: FormBuilder, private addressService: AddressService) { }[m
 [m
   ngOnInit() {[m
[32m+[m[32m      this.initForm();[m
   }[m
[32m+[m[32m    initForm() {[m
[32m+[m[32m        const name = localStorage.getItem('name');[m
[32m+[m[32m        const familyName = localStorage.getItem('familyName');[m
[32m+[m[32m        const phoneNumber = localStorage.getItem('phoneNumber');[m
[32m+[m[32m        this.addressForm = this.formBuilder.group({[m
[32m+[m[32m            customerName: name,[m
[32m+[m[32m            familyName: familyName,[m
[32m+[m[32m            phoneNumber: phoneNumber,[m
[32m+[m[32m            country: '',[m
[32m+[m[32m            city: '',[m
[32m+[m[32m            address: '',[m
[32m+[m[32m            name: '',[m
[32m+[m[32m            postal_code: ''[m
[32m+[m[32m        });[m
[32m+[m[32m    }[m
[32m+[m[32m    onSubmitForm() {[m
[32m+[m[32m        const formValue = this.addressForm.value;[m
[32m+[m[32m        const address = new Address([m
[32m+[m[32m            formValue['country'],[m
[32m+[m[32m            formValue['city'],[m
[32m+[m[32m            formValue['address'],[m
[32m+[m[32m            formValue['name'],[m
[32m+[m[32m            formValue['postal_code'][m
[32m+[m[32m        );[m
[32m+[m[32m        this.addressService.add(address) ;[m
[32m+[m[32m        /* this.router.navigate(['']);*/[m
[32m+[m[32m    }[m
 [m
 }[m
[1mdiff --git a/src/app/app.module.ts b/src/app/app.module.ts[m
[1mindex d2f1e4e..17ac769 100644[m
[1m--- a/src/app/app.module.ts[m
[1m+++ b/src/app/app.module.ts[m
[36m@@ -32,6 +32,7 @@[m [mimport { ContainerComponent } from './container/container.component';[m
 import { CustomerProfileComponent } from './customer-profile/customer-profile.component';[m
 import { JewelryComponent } from './jewelry/jewelry.component';[m
 import { AdressComponent } from './adress/adress.component';[m
[32m+[m[32mimport {AddressService} from './services/address.service';[m
 [m
 [m
 [m
[36m@@ -115,6 +116,7 @@[m [mconst appRoutes: Routes = [[m
       ShopingService,[m
       CustomerService,[m
       AuthGuard,[m
[32m+[m[32m      AddressService,[m
   ],[m
   bootstrap: [AppComponent][m
 })[m
[1mdiff --git a/src/app/models/Address.model.ts b/src/app/models/Address.model.ts[m
[1mindex fcadc5a..adbc88a 100644[m
[1m--- a/src/app/models/Address.model.ts[m
[1m+++ b/src/app/models/Address.model.ts[m
[36m@@ -1,5 +1,9 @@[m
 export class Address {[m
     constructor([m
[31m-        public name: string[m
[32m+[m[32m        public country: string,[m
[32m+[m[32m        public city: string,[m
[32m+[m[32m        public address: string,[m
[32m+[m[32m        public name: string,[m
[32m+[m[32m        public postal_code: string[m
     ) {}[m
 }[m
[1mdiff --git a/src/app/services/address.service.ts b/src/app/services/address.service.ts[m
[1mindex 8aba59d..f7cb10d 100644[m
[1m--- a/src/app/services/address.service.ts[m
[1m+++ b/src/app/services/address.service.ts[m
[36m@@ -1,7 +1,6 @@[m
 import { Injectable } from '@angular/core';[m
 import {Subject} from 'rxjs/Subject';[m
 import {HttpClient} from '@angular/common/http';[m
[31m-import {Order} from '../models/Order.model';[m
 import {Address} from '../models/Address.model';[m
 [m
 @Injectable()[m
[36m@@ -12,8 +11,16 @@[m [mexport class AddressService {[m
     public emitAddressSubject() {[m
         this.addressSubject.next(this.addresses.slice());[m
     }[m
[32m+[m[32m    public getAddresses() {[m
[32m+[m[32m        this.httpClient.get<any[]>('http://localhost:8888/pfe_marketplace/web/app_dev.php/api/customers/addresses').subscribe([m
[32m+[m[32m            (response) => {this.addresses = response;[m
[32m+[m[32m                this.emitAddressSubject();[m
[32m+[m[32m            },[m
[32m+[m[32m            (error) => {console.log('Erreur ! :' + error); }[m
[32m+[m[32m        );[m
[32m+[m[32m    }[m
     saveToServer(body: any) {[m
[31m-        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/customers/addresess';[m
[32m+[m[32m        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/customers/addresses';[m
         const b = JSON.stringify(body);[m
         this.httpClient.post(url, b, {[m
             headers: {'Content-Type': 'application/json'}[m

[33mcommit e27a2ecbdfd318e94e5c05d0fb4679e674cf705e[m
Author: Nouha <nouha.bensalem1992@gmail.com>
Date:   Sat May 5 17:11:44 2018 +0100

    fix the adress delevery style

[1mdiff --git a/src/app/adress/adress.component.html b/src/app/adress/adress.component.html[m
[1mindex f929c8c..78ce0de 100644[m
[1m--- a/src/app/adress/adress.component.html[m
[1m+++ b/src/app/adress/adress.component.html[m
[36m@@ -28,7 +28,7 @@[m
 </div>[m
 <!--breadcrump end-->[m
 [m
[31m-<!--form Start-->[m
[32m+[m[32m<!--form Start[m
 [m
 <div class="content">[m
     <form method="post" action="#" class="forms">[m
[36m@@ -77,7 +77,7 @@[m
             </div>[m
             <div class="col _s12 _m6">[m
                 <label>Code postal* :[m
[31m-                    <input class="input_1" type="number" name="f-email" placeholder="12345">[m
[32m+[m[32m                    <input class="input_1" type="text" name="f-email" placeholder="Code postal">[m
                     <span class="grey-line"></span>[m
                     <span class="blue-line"></span>[m
                 </label>[m
[36m@@ -114,3 +114,80 @@[m
     </form>[m
 </div>[m
 [m
[32m+[m[32m-->[m
[32m+[m
[32m+[m
[32m+[m[32m<div class="banner_bottom_agile_info">[m
[32m+[m[32m    <div class="container">[m
[32m+[m[32m        <div class="agile-contact-grids">[m
[32m+[m[32m            <div class="agile-contact-left">[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m[32m                <div class="col-md-12 contact-form">[m
[32m+[m[32m                    <h4 class="white-w3ls">CREATION D'UNE ADRESSE DE <span>LIVRAISON</span></h4>[m
[32m+[m[32m                    <form  [formGroup]="addressForm" (ngSubmit)="onSubmitForm()">[m
[32m+[m[32m                        <div class="styled-input agile-styled-input-top">[m
[32m+[m[32m                            <input type="text" id="name" placeholder="Prénom" formControlName="name">[m
[32m+[m[32m                            <p class="error_message" *ngIf="customerForm.get('name').invalid">Veuillez fournir au moins 3 caractères.</p>[m
[32m+[m[32m                            <label  for="name">Prénom* :</label>[m
[32m+[m[32m                            <span></span>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <div class="styled-input">[m
[32m+[m[32m                            <input type="text" id="family-name" placeholder="Nom" formControlName="familyName">[m
[32m+[m[32m                            <p class="error_message" *ngIf="customerForm.get('familyName').invalid">Veuillez fournir au moins 3 caractères.</p>[m
[32m+[m[32m                            <label for="family-name">Nom* :</label>[m
[32m+[m[32m                            <span></span>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <div class="styled-input">[m
[32m+[m[32m                            <input type="text" id="tel" placeholder="Numéro de téléphone" formControlName="phoneNumber">[m
[32m+[m[32m                            <label for="tel">Numéro de télephone* :</label>[m
[32m+[m[32m                            <span></span>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <div class="styled-input">[m
[32m+[m[32m                            <input type="text" id="address" placeholder="Rue, numéro, étage,..." formControlName="address">[m
[32m+[m[32m                            <label  for="address">Adresse* :</label>[m
[32m+[m[32m                            <span></span>[m
[32m+[m[32m                        </div>[m
[32m+[m
[32m+[m
[32m+[m[32m                        <div class="col-md-6 mb-3">[m
[32m+[m
[32m+[m[32m                            <div class="styled-input">[m
[32m+[m[32m                                <input type="text" id="city" placeholder="Ville" formControlName="city">[m
[32m+[m[32m                                <label  for="city">Ville* :</label>[m
[32m+[m[32m                                <span></span>[m
[32m+[m[32m                            </div>[m
[32m+[m[32m                        </div>[m
[32m+[m
[32m+[m[32m                        <div class="col-md-6 mb-3">[m
[32m+[m[32m                            <div class="styled-input">[m
[32m+[m[32m                                <input type="text" id="postalcode" placeholder="Code postal" formControlName="postalcode">[m
[32m+[m[32m                                <label  for="postalcode">Code postal* :</label>[m
[32m+[m[32m                                <span></span>[m
[32m+[m[32m                            </div>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <br>[m
[32m+[m[32m                        <br><br>[m
[32m+[m
[32m+[m[32m                        <div class="styled-input">[m
[32m+[m[32m                        <select class="form-control" >[m
[32m+[m[32m                            <option>France</option>[m
[32m+[m[32m                        </select>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <div class="styled-input">[m
[32m+[m[32m                            <input type="text" id="name-address" placeholder="Domicile" formControlName="name">[m
[32m+[m[32m                            <label  for="name-address">Donner un nom à cette adresse* : Bureau, maison ...</label>[m
[32m+[m[32m                            <span></span>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                           <p> (*Champs obligatoires)</p>[m
[32m+[m[32m                        <br>[m
[32m+[m[32m                        <div  style="float: right;">[m
[32m+[m[32m                            <input type="submit" value="Valider cette adresse" [disabled]="customerForm.invalid">[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                    </form>[m
[32m+[m[32m                </div>[m
[32m+[m[32m            </div>[m
[32m+[m[32m        </div>[m
[32m+[m[32m    </div>[m
[32m+[m[32m</div>[m
\ No newline at end of file[m
[1mdiff --git a/src/app/adress/adress.component.scss b/src/app/adress/adress.component.scss[m
[1mindex 7e648f7..9d3093c 100644[m
[1m--- a/src/app/adress/adress.component.scss[m
[1m+++ b/src/app/adress/adress.component.scss[m
[36m@@ -1,3 +1,8 @@[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
 /*breadcrump*/[m
 .bs-wizard {margin-top: 40px;}[m
 [m
[36m@@ -19,978 +24,4 @@[m
 .bs-wizard > .bs-wizard-step.disabled > .bs-wizard-dot:after {opacity: 0;}[m
 .bs-wizard > .bs-wizard-step:first-child  > .progress {left: 50%; width: 50%;}[m
 .bs-wizard > .bs-wizard-step:last-child  > .progress {width: 50%;}[m
[31m-.bs-wizard > .bs-wizard-step.disabled a.bs-wizard-dot{ pointer-events: none; }[m
[31m-[m
[31m-/* form style */[m
[31m-*{[m
[31m-  -webkit-box-sizing: border-box; /* Safari/Chrome, other WebKit */[m
[31m-  -moz-box-sizing: border-box;    /* Firefox, other Gecko */[m
[31m-  box-sizing: border-box;[m
[31m-  font-family: "Open Sans";[m
[31m-}[m
[31m-[m
[31m-h3{[m
[31m-  font-weight: 300;[m
[31m-}[m
[31m-[m
[31m-.r-field{[m
[31m-  font-weight: 400;[m
[31m-  font-size: 12px;[m
[31m-  color: #111111;[m
[31m-}[m
[31m-.content{[m
[31m-  width: 50%;[m
[31m-  margin: 0 auto;[m
[31m-}[m
[31m-@media (max-width: 800px) {[m
[31m-  .content{[m
[31m-    width: 100%;[m
[31m-  }[m
[31m-}[m
[31m-form{[m
[31m-  -webkit-box-sizing: border-box; /* Safari/Chrome, other WebKit */[m
[31m-  -moz-box-sizing: border-box;    /* Firefox, other Gecko */[m
[31m-  box-sizing: border-box;[m
[31m-  font-family:"Pt sans";[m
[31m-[m
[31m-  position:relative;[m
[31m-  width: 100%;[m
[31m-  margin: 0 auto;[m
[31m-}[m
[31m-[m
[31m-label{[m
[31m-  font-weight: bold;[m
[31m-  display:block;[m
[31m-  color: #2fdab8;[m
[31m-  padding-bottom: 5px;[m
[31m-  width: 100%;[m
[31m-  margin: 0 auto;[m
[31m-  position: relative;[m
[31m-  margin-bottom:5px;[m
[31m-  font-weight:400;[m
[31m-}[m
[31m-[m
[31m-.input_1{[m
[31m-  width: 100%;[m
[31m-  height: 28px;[m
[31m-  border: none;[m
[31m-  background-color: #ECECEC;[m
[31m-  padding-left: 10px;[m
[31m-  box-shadow: none;[m
[31m-  outline: none;[m
[31m-  position: relative;[m
[31m-  display:block;[m
[31m-  -webkit-box-sizing: border-box; /* Safari/Chrome, other WebKit */[m
[31m-  -moz-box-sizing: border-box;    /* Firefox, other Gecko */[m
[31m-  box-sizing: border-box;[m
[31m-[m
[31m-  margin-top:10px;[m
[31m-}[m
[31m-[m
[31m-.blue-line-left{[m
[31m-[m
[31m-  background: #49E;[m
[31m-  position: absolute;[m
[31m-  left: -1px;[m
[31m-  width: 1px;[m
[31m-  height: 28px;[m
[31m-  bottom:5px;[m
[31m-  transition: all .2s;[m
[31m-  -webkit-box-sizing: border-box; /* Safari/Chrome, other WebKit */[m
[31m-  -moz-box-sizing: border-box;    /* Firefox, other Gecko */[m
[31m-  box-sizing: border-box;[m
[31m-}[m
[31m-[m
[31m-[m
[31m-.blue-line {[m
[31m-  display: block;[m
[31m-  width: 0;[m
[31m-  height: 1px;[m
[31m-  background: #49E;[m
[31m-  position: absolute;[m
[31m-[m
[31m-  transition: all .2s;[m
[31m-}[m
[31m-[m
[31m-.input_1:focus ~ .blue-line{[m
[31m-  width: 100%;[m
[31m-}[m
[31m-[m
[31m-.input_1:focus + .blue-line-left{[m
[31m-  height: 0;[m
[31m-}[m
[31m-[m
[31m-.grey-line {[m
[31m-  display: block;[m
[31m-  width: 0;[m
[31m-  height: 1px;[m
[31m-  background: #ccc;[m
[31m-  position: absolute;[m
[31m-  transition: all .2s;[m
[31m-}[m
[31m-.input_1:hover ~ .grey-line {[m
[31m-  width: 100%;[m
[31m-[m
[31m-}[m
[31m-[m
[31m-.input_1:invalid ~ .blue-line,[m
[31m-.input_1.isUnvalid ~ .blue-line{[m
[31m-  width: 100%;[m
[31m-  height: 2px;[m
[31m-  background-color: #F70600;[m
[31m-}[m
[31m-.input_1:invalid ~ .blue-line:after,[m
[31m-.input_1.isUnvalid ~ .blue-line:after{[m
[31m-  position: absolute;[m
[31m-  top: -28px;[m
[31m-  left: -12px;[m
[31m-  font-size: 20px;[m
[31m-  color: #F70600;[m
[31m-}[m
[31m-[m
[31m-.input_1.isValid ~ .blue-line{[m
[31m-  width: 100%;[m
[31m-}[m
[31m-[m
[31m-[m
[31m-.field-icon{[m
[31m-  position: absolute;[m
[31m-  padding-left: 6px;[m
[31m-  font-size: 18px;[m
[31m-  padding-top: 2px;[m
[31m-  color: #929292;[m
[31m-  pointer-events: none;[m
[31m-  left: 0;[m
[31m-  z-index: 2;[m
[31m-}[m
[31m-[m
[31m-.content-input-icon input{[m
[31m-  padding-left: 28px;[m
[31m-}[m
[31m-[m
[31m-textarea{[m
[31m-  position: relative;[m
[31m-  display:block;[m
[31m-  width: 100%;[m
[31m-  border: 1px solid transparent;[m
[31m-  background-color: #ECECEC;[m
[31m-  resize: none;[m
[31m-  font-size: 14px;[m
[31m-}[m
[31m-textarea:hover{[m
[31m-  border-color: #ddd;[m
[31m-}[m
[31m-textarea:focus{[m
[31m-  border-color: #49E;[m
[31m-}[m
[31m-[m
[31m-[m
[31m-select{[m
[31m-  position: relative;[m
[31m-  display:block;[m
[31m-  margin-top:10px;[m
[31m-  height: 28px;[m
[31m-  width:100%;[m
[31m-  border: 1px solid transparent;[m
[31m-  background-color: #ECECEC;[m
[31m-  box-shadow: none;[m
[31m-}[m
[31m-select:hover{[m
[31m-  border-color: #ccc;[m
[31m-}[m
[31m-select:focus{[m
[31m-  border-color: #49E;[m
[31m-}[m
[31m-[m
[31m-.checkbox{[m
[31m-  font-size: 14px;[m
[31m-}[m
[31m-.checkbox ul{[m
[31m-  list-style-type: none;[m
[31m-  margin: 0;[m
[31m-  padding: 0;[m
[31m-}[m
[31m-.checkbox ul li{[m
[31m-  margin-bottom: 12px;[m
[31m-}[m
[31m-[m
[31m-.checkbox input{[m
[31m-  display: inline;[m
[31m-}[m
[31m-[m
[31m-.checkbox label{[m
[31m-  display: inline;[m
[31m-}[m
[31m-[m
[31m-[type="checkbox"]{[m
[31m-  position: absolute;[m
[31m-  left: -9999px;[m
[31m-}[m
[31m-[type="checkbox"] + label,[m
[31m-[type="checkbox"]:checked + label {[m
[31m-  position: relative;[m
[31m-  padding-left: 25px;[m
[31m-  cursor: pointer;[m
[31m-}[m
[31m-[type="checkbox"] + label:before,[m
[31m-[type="checkbox"]:checked + label:before {[m
[31m-  content: '';[m
[31m-  position: absolute;[m
[31m-  left:0; top: -1px;[m
[31m-  width: 17px; height: 17px;[m
[31m-  border: 1px solid #bbb;[m
[31m-  background: #fff;[m
[31m-  border-radius: 2px;[m
[31m-}[m
[31m-[m
[31m-[type="checkbox"] + label:after,[m
[31m-[type="checkbox"]:checked + label:after {[m
[31m-  content: '✔';[m
[31m-  position: absolute;[m
[31m-  top: 2px; left: 3px;[m
[31m-  font-size: 19px;[m
[31m-  line-height: 0.8;[m
[31m-  color: #49E;[m
[31m-  transition: all .2s;[m
[31m-}[m
[31m-[type="checkbox"] + label:after {[m
[31m-  opacity: 0;[m
[31m-  transform: scale(0);[m
[31m-}[m
[31m-[type="checkbox"]:checked + label:after {[m
[31m-  opacity: 1;[m
[31m-  transform: scale(1);[m
[31m-}[m
[31m-/* disabled checkbox */[m
[31m-[type="checkbox"]:disabled + label:before,[m
[31m-[type="checkbox"]:disabled:checked + label:before {[m
[31m-  border-color: #bbb;[m
[31m-  background-color: #ddd;[m
[31m-}[m
[31m-[type="checkbox"]:disabled:checked + label:after {[m
[31m-  color: #919191;[m
[31m-}[m
[31m-[type="checkbox"]:disabled + label {[m
[31m-  color: #919191;[m
[31m-}[m
[31m-[type="checkbox"]:checked:focus + label:before,[m
[31m-[type="checkbox"]:focus + label:before {[m
[31m-  border: 1px dotted #49E;[m
[31m-}[m
[31m-[m
[31m-.checkbox label:hover:before {[m
[31m-  border: 1px solid #4778d9!important;[m
[31m-}[m
[31m-[m
[31m-.radios ul{[m
[31m-  list-style: none;[m
[31m-  height: 100%;[m
[31m-  width: 100%;[m
[31m-  margin: 0;[m
[31m-  padding: 0;[m
[31m-}[m
[31m-[m
[31m-.radios label{[m
[31m-  color : #7A7A7A;[m
[31m-}[m
[31m-.radios ul li{[m
[31m-  color: #AAAAAA;[m
[31m-  display: block;[m
[31m-  position: relative;[m
[31m-  width: 100%;[m
[31m-  margin-bottom: 8px;[m
[31m-}[m
[31m-[m
[31m-.radios ul li input[type=radio]{[m
[31m-  position: absolute;[m
[31m-  visibility: hidden;[m
[31m-}[m
[31m-[m
[31m-.radios ul li label{[m
[31m-  display: block;[m
[31m-  display: inline-block;[m
[31m-  position: relative;[m
[31m-  font-weight: 400;[m
[31m-  font-size: 14px;[m
[31m-  padding: 0px 0px 0px 25px;[m
[31m-  margin: 0;[m
[31m-  z-index: 9;[m
[31m-  cursor: pointer;[m
[31m-}[m
[31m-[m
[31m-.radios ul li:hover label{[m
[31m-  color: #49E;[m
[31m-}[m
[31m-[m
[31m-.radios ul li .check{[m
[31m-  display: inline-block;[m
[31m-  position: absolute;[m
[31m-  border: 2px solid #AAAAAA;[m
[31m-  border-radius: 100%;[m
[31m-  height: 16px;[m
[31m-  width: 16px;[m
[31m-  top: 5px;[m
[31m-  left: 0px;[m
[31m-  z-index: 5;[m
[31m-  transition: border .2s linear;[m
[31m-  -webkit-transition: border .2s linear;[m
[31m-}[m
[31m-[m
[31m-.radios ul li:hover .check {[m
[31m-  border: 2px solid #49E;[m
[31m-}[m
[31m-[m
[31m-.radios ul li .check::before {[m
[31m-  display: block;[m
[31m-  position: absolute;[m
[31m-  content: '';[m
[31m-  border-radius: 100%;[m
[31m-  height: 8px;[m
[31m-  width: 8px;[m
[31m-  top: 2px;[m
[31m-  left: 2px;[m
[31m-  margin: auto;[m
[31m-  transition: background 0.2s linear;[m
[31m-  -webkit-transition: background 0.2s linear;[m
[31m-}[m
[31m-[m
[31m-.radios input[type=radio]:checked ~ .check {[m
[31m-  border: 2px solid #49E;[m
[31m-}[m
[31m-[m
[31m-.radios input[type=radio]:checked ~ .check::before{[m
[31m-  background: #49E;[m
[31m-}[m
[31m-[m
[31m-.radios input[type=radio]:checked ~ label{[m
[31m-  color: #49E;[m
[31m-}[m
[31m-[m
[31m-[m
[31m-.button{[m
[31m-  position:relative;[m
[31m-  display:inline-block;[m
[31m-  margin-top: 15px;[m
[31m-  padding-left: 40px;[m
[31m-  padding-right: 40px;[m
[31m-  padding-top: 10px;[m
[31m-  padding-bottom: 10px;[m
[31m-  background-color: #2fdab8;[m
[31m-  border: 1px solid transparent;[m
[31m-  border-radius: 2px;[m
[31m-  font-size: 15px;[m
[31m-  font-weight: 400;[m
[31m-  color: #fafafa;[m
[31m-  text-decoration: none;[m
[31m-  transition: all 0.2s ease;[m
[31m-  &.round{[m
[31m-    border-radius: 25px;[m
[31m-    border: none;[m
[31m-  }[m
[31m-  &:hover{[m
[31m-    background-color: #2fdab8;[m
[31m-    font-size: 16px;[m
[31m-[m
[31m-  }[m
[31m-[m
[31m-}[m
[31m-[m
[31m-[m
[31m-.container {[m
[31m-  margin: 0 auto;[m
[31m-  max-width: 1280px;[m
[31m-  width: 90%;[m
[31m-}[m
[31m-[m
[31m-@media only screen and (min-width: 601px) {[m
[31m-  .container {[m
[31m-    width: 85%;[m
[31m-  }[m
[31m-}[m
[31m-@media only screen and (min-width: 993px) {[m
[31m-  .container {[m
[31m-    width: 70%;[m
[31m-  }[m
[31m-}[m
[31m-.container .row {[m
[31m-  margin-left: -0.75rem;[m
[31m-  margin-right: -0.75rem;[m
[31m-}[m
[31m-[m
[31m-.section {[m
[31m-  padding-top: 1rem;[m
[31m-  padding-bottom: 1rem;[m
[31m-}[m
[31m-.section.no-pad {[m
[31m-  padding: 0;[m
[31m-}[m
[31m-.section.no-pad-bot {[m
[31m-  padding-bottom: 0;[m
[31m-}[m
[31m-.section.no-pad-top {[m
[31m-  padding-top: 0;[m
[31m-}[m
[31m-[m
[31m-.row {[m
[31m-  margin-left: auto;[m
[31m-  margin-right: auto;[m
[31m-  margin-bottom: 20px;[m
[31m-}[m
[31m-.row:after {[m
[31m-  content: "";[m
[31m-  display: table;[m
[31m-  clear: both;[m
[31m-}[m
[31m-.row .col {[m
[31m-  float: left;[m
[31m-  box-sizing: border-box;[m
[31m-  padding: 0 0.75rem;[m
[31m-  min-height: 1px;[m
[31m-}[m
[31m-.row .col[class*="push-"], .row .col[class*="pull-"] {[m
[31m-  position: relative;[m
[31m-}[m
[31m-.row .col._s1 {[m
[31m-  width: 8.33333333%;[m
[31m-  margin-left: auto;[m
[31m-  left: auto;[m
[31m-  right: auto;[m
[31m-}[m
[31m-.row .col._s2 {[m
[31m-  width: 16.66666667%;[m
[31m-  margin-left: auto;[m
[31m-  left: auto;[m
[31m-  right: auto;[m
[31m-}[m
[31m-.row .col._s3 {[m
[31m-  width: 25%;[m
[31m-  margin-left: auto;[m
[31m-  left: auto;[m
[31m-  right: auto;[m
[31m-}[m
[31m-.row .col._s4 {[m
[31m-  width: 33.33333333%;[m
[31m-  margin-left: auto;[m
[31m-  left: auto;[m
[31m-  right: auto;[m
[31m-}[m
[31m-.row .col._s5 {[m
[31m-  width: 41.66666667%;[m
[31m-  margin-left: auto;[m
[31m-  left: auto;[m
[31m-  right: auto;[m
[31m-}[m
[31m-.row .col._s6 {[m
[31m-  width: 50%;[m
[31m-  margin-left: auto;[m
[31m-  left: auto;[m
[31m-  right: auto;[m
[31m-}[m
[31m-.row .col._s7 {[m
[31m-  width: 58.33333333%;[m
[31m-  margin-left: auto;[m
[31m-  left: auto;[m
[31m-  right: auto;[m
[31m-}[m
[31m-.row .col._s8 {[m
[31m-  width: 66.66666667%;[m
[31m-  margin-left: auto;[m
[31m-  left: auto;[m
[31m-  right: auto;[m
[31m-}[m
[31m-.row .col._s9 {[m
[31m-  width: 75%;[m
[31m-  margin-left: auto;[m
[31m-  left: auto;[m
[31m-  right: auto;[m
[31m-}[m
[31m-.row .col._s10 {[m
[31m-  width: 83.33333333%;[m
[31m-  margin-left: auto;[m
[31m-  left: auto;[m
[31m-  right: auto;[m
[31m-}[m
[31m-.row .col._s11 {[m
[31m-  width: 91.66666667%;[m
[31m-  margin-left: auto;[m
[31m-  left: auto;[m
[31m-  right: auto;[m
[31m-}[m
[31m-.row .col._s12 {[m
[31m-  width: 100%;[m
[31m-  margin-left: auto;[m
[31m-  left: auto;[m
[31m-  right: auto;[m
[31m-}[m
[31m-.row .col._offset-s1 {[m
[31m-  margin-left: 8.33333333%;[m
[31m-}[m
[31m-.row .col._pull-s1 {[m
[31m-  right: 8.33333333%;[m
[31m-}[m
[31m-.row .col._push-s1 {[m
[31m-  left: 8.33333333%;[m
[31m-}[m
[31m-.row .col._offset-s2 {[m
[31m-  margin-left: 16.66666667%;[m
[31m-}[m
[31m-.row .col._pull-s2 {[m
[31m-  right: 16.66666667%;[m
[31m-}[m
[31m-.row .col._push-s2 {[m
[31m-  left: 16.66666667%;[m
[31m-}[m
[31m-.row .col._offset-s3 {[m
[31m-  margin-left: 25%;[m
[31m-}[m
[31m-.row .col._pull-s3 {[m
[31m-  right: 25%;[m
[31m-}[m
[31m-.row .col._push-s3 {[m
[31m-  left: 25%;[m
[31m-}[m
[31m-.row .col._offset-s4 {[m
[31m-  margin-left: 33.33333333%;[m
[31m-}[m
[31m-.row .col._pull-s4 {[m
[31m-  right: 33.33333333%;[m
[31m-}[m
[31m-.row .col._push-s4 {[m
[31m-  left: 33.33333333%;[m
[31m-}[m
[31m-.row .col._offset-s5 {[m
[31m-  margin-left: 41.66666667%;[m
[31m-}[m
[31m-.row .col._pull-s5 {[m
[31m-  right: 41.66666667%;[m
[31m-}[m
[31m-.row .col._push-s5 {[m
[31m-  left: 41.66666667%;[m
[31m-}[m
[31m-.row .col._offset-s6 {[m
[31m-  margin-left: 50%;[m
[31m-}[m
[31m-.row .col._pull-s6 {[m
[31m-  right: 50%;[m
[31m-}[m
[31m-.row .col._push-s6 {[m
[31m-  left: 50%;[m
[31m-}[m
[31m-.row .col._offset-s7 {[m
[31m-  margin-left: 58.33333333%;[m
[31m-}[m
[31m-.row .col._pull-s7 {[m
[31m-  right: 58.33333333%;[m
[31m-}[m
[31m-.row .col._push-s7 {[m
[31m-  left: 58.33333333%;[m
[31m-}[m
[31m-.row .col._offset-s8 {[m
[31m-  margin-left: 66.66666667%;[m
[31m-}[m
[31m-.row .col._pull-s8 {[m
[31m-  right: 66.66666667%;[m
[31m-}[m
[31m-.row .col._push-s8 {[m
[31m-  left: 66.66666667%;[m
[31m-}[m
[31m-.row .col._offset-s9 {[m
[31m-  margin-left: 75%;[m
[31m-}[m
[31m-.row .col._pull-s9 {[m
[31m-  right: 75%;[m
[31m-}[m
[31m-.row .col._push-s9 {[m
[31m-  left: 75%;[m
[31m-}[m
[31m-.row .col._offset-s10 {[m
[31m-  margin-left: 83.33333333%;[m
[31m-}[m
[31m-.row .col._pull-s10 {[m
[31m-  right: 83.33333333%;[m
[31m-}[m
[31m-.row .col._push-s10 {[m
[31m-  left: 83.33333333%;[m
[31m-}[m
[31m-.row .col._offset-s11 {[m
[31m-  margin-left: 91.66666667%;[m
[31m-}[m
[31m-.row .col._pull-s11 {[m
[31m-  right: 91.66666667%;[m
[31m-}[m
[31m-.row .col._push-s11 {[m
[31m-  left: 91.66666667%;[m
[31m-}[m
[31m-.row .col._offset-s12 {[m
[31m-  margin-left: 100%;[m
[31m-}[m
[31m-.row .col._pull-s12 {[m
[31m-  right: 100%;[m
[31m-}[m
[31m-.row .col._push-s12 {[m
[31m-  left: 100%;[m
[31m-}[m
[31m-@media only screen and (min-width: 601px) {[m
[31m-  .row .col._m1 {[m
[31m-    width: 8.33333333%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._m2 {[m
[31m-    width: 16.66666667%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._m3 {[m
[31m-    width: 25%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._m4 {[m
[31m-    width: 33.33333333%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._m5 {[m
[31m-    width: 41.66666667%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._m6 {[m
[31m-    width: 50%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._m7 {[m
[31m-    width: 58.33333333%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._m8 {[m
[31m-    width: 66.66666667%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._m9 {[m
[31m-    width: 75%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._m10 {[m
[31m-    width: 83.33333333%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._m11 {[m
[31m-    width: 91.66666667%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._m12 {[m
[31m-    width: 100%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._offset-m1 {[m
[31m-    margin-left: 8.33333333%;[m
[31m-  }[m
[31m-  .row .col._pull-m1 {[m
[31m-    right: 8.33333333%;[m
[31m-  }[m
[31m-  .row .col._push-m1 {[m
[31m-    left: 8.33333333%;[m
[31m-  }[m
[31m-  .row .col._offset-m2 {[m
[31m-    margin-left: 16.66666667%;[m
[31m-  }[m
[31m-  .row .col._pull-m2 {[m
[31m-    right: 16.66666667%;[m
[31m-  }[m
[31m-  .row .col._push-m2 {[m
[31m-    left: 16.66666667%;[m
[31m-  }[m
[31m-  .row .col._offset-m3 {[m
[31m-    margin-left: 25%;[m
[31m-  }[m
[31m-  .row .col._pull-m3 {[m
[31m-    right: 25%;[m
[31m-  }[m
[31m-  .row .col._push-m3 {[m
[31m-    left: 25%;[m
[31m-  }[m
[31m-  .row .col._offset-m4 {[m
[31m-    margin-left: 33.33333333%;[m
[31m-  }[m
[31m-  .row .col._pull-m4 {[m
[31m-    right: 33.33333333%;[m
[31m-  }[m
[31m-  .row .col._push-m4 {[m
[31m-    left: 33.33333333%;[m
[31m-  }[m
[31m-  .row .col._offset-m5 {[m
[31m-    margin-left: 41.66666667%;[m
[31m-  }[m
[31m-  .row .col._pull-m5 {[m
[31m-    right: 41.66666667%;[m
[31m-  }[m
[31m-  .row .col._push-m5 {[m
[31m-    left: 41.66666667%;[m
[31m-  }[m
[31m-  .row .col._offset-m6 {[m
[31m-    margin-left: 50%;[m
[31m-  }[m
[31m-  .row .col._pull-m6 {[m
[31m-    right: 50%;[m
[31m-  }[m
[31m-  .row .col._push-m6 {[m
[31m-    left: 50%;[m
[31m-  }[m
[31m-  .row .col._offset-m7 {[m
[31m-    margin-left: 58.33333333%;[m
[31m-  }[m
[31m-  .row .col._pull-m7 {[m
[31m-    right: 58.33333333%;[m
[31m-  }[m
[31m-  .row .col._push-m7 {[m
[31m-    left: 58.33333333%;[m
[31m-  }[m
[31m-  .row .col._offset-m8 {[m
[31m-    margin-left: 66.66666667%;[m
[31m-  }[m
[31m-  .row .col._pull-m8 {[m
[31m-    right: 66.66666667%;[m
[31m-  }[m
[31m-  .row .col._push-m8 {[m
[31m-    left: 66.66666667%;[m
[31m-  }[m
[31m-  .row .col._offset-m9 {[m
[31m-    margin-left: 75%;[m
[31m-  }[m
[31m-  .row .col._pull-m9 {[m
[31m-    right: 75%;[m
[31m-  }[m
[31m-  .row .col._push-m9 {[m
[31m-    left: 75%;[m
[31m-  }[m
[31m-  .row .col._offset-m10 {[m
[31m-    margin-left: 83.33333333%;[m
[31m-  }[m
[31m-  .row .col._pull-m10 {[m
[31m-    right: 83.33333333%;[m
[31m-  }[m
[31m-  .row .col._push-m10 {[m
[31m-    left: 83.33333333%;[m
[31m-  }[m
[31m-  .row .col._offset-m11 {[m
[31m-    margin-left: 91.66666667%;[m
[31m-  }[m
[31m-  .row .col._pull-m11 {[m
[31m-    right: 91.66666667%;[m
[31m-  }[m
[31m-  .row .col._push-m11 {[m
[31m-    left: 91.66666667%;[m
[31m-  }[m
[31m-  .row .col._offset-m12 {[m
[31m-    margin-left: 100%;[m
[31m-  }[m
[31m-  .row .col._pull-m12 {[m
[31m-    right: 100%;[m
[31m-  }[m
[31m-  .row .col._push-m12 {[m
[31m-    left: 100%;[m
[31m-  }[m
[31m-}[m
[31m-@media only screen and (min-width: 993px) {[m
[31m-  .row .col._l1 {[m
[31m-    width: 8.33333333%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._l2 {[m
[31m-    width: 16.66666667%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._l3 {[m
[31m-    width: 25%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._l4 {[m
[31m-    width: 33.33333333%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._l5 {[m
[31m-    width: 41.66666667%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._l6 {[m
[31m-    width: 50%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._l7 {[m
[31m-    width: 58.33333333%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._l8 {[m
[31m-    width: 66.66666667%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._l9 {[m
[31m-    width: 75%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._l10 {[m
[31m-    width: 83.33333333%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._l11 {[m
[31m-    width: 91.66666667%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._l12 {[m
[31m-    width: 100%;[m
[31m-    margin-left: auto;[m
[31m-    left: auto;[m
[31m-    right: auto;[m
[31m-  }[m
[31m-  .row .col._offset-l1 {[m
[31m-    margin-left: 8.33333333%;[m
[31m-  }[m
[31m-  .row .col._pull-l1 {[m
[31m-    right: 8.33333333%;[m
[31m-  }[m
[31m-  .row .col._push-l1 {[m
[31m-    left: 8.33333333%;[m
[31m-  }[m
[31m-  .row .col._offset-l2 {[m
[31m-    margin-left: 16.66666667%;[m
[31m-  }[m
[31m-  .row .col._pull-l2 {[m
[31m-    right: 16.66666667%;[m
[31m-  }[m
[31m-  .row .col._push-l2 {[m
[31m-    left: 16.66666667%;[m
[31m-  }[m
[31m-  .row .col._offset-l3 {[m
[31m-    margin-left: 25%;[m
[31m-  }[m
[31m-  .row .col._pull-l3 {[m
[31m-    right: 25%;[m
[31m-  }[m
[31m-  .row .col._push-l3 {[m
[31m-    left: 25%;[m
[31m-  }[m
[31m-  .row .col._offset-l4 {[m
[31m-    margin-left: 33.33333333%;[m
[31m-  }[m
[31m-  .row .col._pull-l4 {[m
[31m-    right: 33.33333333%;[m
[31m-  }[m
[31m-  .row .col._push-l4 {[m
[31m-    left: 33.33333333%;[m
[31m-  }[m
[31m-  .row .col._offset-l5 {[m
[31m-    margin-left: 41.66666667%;[m
[31m-  }[m
[31m-  .row .col._pull-l5 {[m
[31m-    right: 41.66666667%;[m
[31m-  }[m
[31m-  .row .col._push-l5 {[m
[31m-    left: 41.66666667%;[m
[31m-  }[m
[31m-  .row .col._offset-l6 {[m
[31m-    margin-left: 50%;[m
[31m-  }[m
[31m-  .row .col._pull-l6 {[m
[31m-    right: 50%;[m
[31m-  }[m
[31m-  .row .col._push-l6 {[m
[31m-    left: 50%;[m
[31m-  }[m
[31m-  .row .col._offset-l7 {[m
[31m-    margin-left: 58.33333333%;[m
[31m-  }[m
[31m-  .row .col._pull-l7 {[m
[31m-    right: 58.33333333%;[m
[31m-  }[m
[31m-  .row .col._push-l7 {[m
[31m-    left: 58.33333333%;[m
[31m-  }[m
[31m-  .row .col._offset-l8 {[m
[31m-    margin-left: 66.66666667%;[m
[31m-  }[m
[31m-  .row .col._pull-l8 {[m
[31m-    right: 66.66666667%;[m
[31m-  }[m
[31m-  .row .col._push-l8 {[m
[31m-    left: 66.66666667%;[m
[31m-  }[m
[31m-  .row .col._offset-l9 {[m
[31m-    margin-left: 75%;[m
[31m-  }[m
[31m-  .row .col._pull-l9 {[m
[31m-    right: 75%;[m
[31m-  }[m
[31m-  .row .col._push-l9 {[m
[31m-    left: 75%;[m
[31m-  }[m
[31m-  .row .col._offset-l10 {[m
[31m-    margin-left: 83.33333333%;[m
[31m-  }[m
[31m-  .row .col._pull-l10 {[m
[31m-    right: 83.33333333%;[m
[31m-  }[m
[31m-  .row .col._push-l10 {[m
[31m-    left: 83.33333333%;[m
[31m-  }[m
[31m-  .row .col._offset-l11 {[m
[31m-    margin-left: 91.66666667%;[m
[31m-  }[m
[31m-  .row .col._pull-l11 {[m
[31m-    right: 91.66666667%;[m
[31m-  }[m
[31m-  .row .col._push-l11 {[m
[31m-    left: 91.66666667%;[m
[31m-  }[m
[31m-  .row .col._offset-l12 {[m
[31m-    margin-left: 100%;[m
[31m-  }[m
[31m-  .row .col._pull-l12 {[m
[31m-    right: 100%;[m
[31m-  }[m
[31m-  .row .col._push-l12 {[m
[31m-    left: 100%;[m
[31m-  }[m
[31m-}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.disabled a.bs-wizard-dot{ pointer-events: none; }[m
\ No newline at end of file[m

[33mcommit f5e30cc1b62ec5f339597896386e3e9ae0c55a98[m
Merge: fe86bf6 9ece36a
Author: Nouha <nouha.bensalem1992@gmail.com>
Date:   Sat May 5 15:39:38 2018 +0100

    Merge branch 'master' of https://github.com/HanoSoft/marketplace-angular

[33mcommit fe86bf6eecbda84dcd425c85adaf24176072ebeb[m
Author: Nouha <nouha.bensalem1992@gmail.com>
Date:   Sat May 5 15:36:26 2018 +0100

    update the address delevery styl

[1mdiff --git a/src/app/adress/adress.component.html b/src/app/adress/adress.component.html[m
[1mindex 025fd2b..684dbb3 100644[m
[1m--- a/src/app/adress/adress.component.html[m
[1m+++ b/src/app/adress/adress.component.html[m
[36m@@ -37,21 +37,21 @@[m
             <h3>Informations</h3>[m
             <div class="col _s12 _m6">[m
                 <label>Prénom* :[m
[31m-                    <input class="input_1" type="text" name="f-name" placeholder="Prénom" required>[m
[32m+[m[32m                    <input class="input_1" type="text" name="f-name" placeholder="" required>[m
                     <span class="grey-line"></span>[m
                     <span class="blue-line"></span>[m
                 </label>[m
             </div>[m
             <div class="col _s12 _m6">[m
                 <label>Nom* :[m
[31m-                    <input class="input_1" type="text" name="f-name" placeholder="Nom" required>[m
[32m+[m[32m                    <input class="input_1" type="text" name="f-name" placeholder="" required>[m
                     <span class="grey-line"></span>[m
                     <span class="blue-line"></span>[m
                 </label>[m
             </div>[m
             <div class="col _s12 _m12">[m
                 <label>Télephone* :[m
[31m-                    <input class="input_1" type="number" name="f-email" placeholder="06 01 02 03 04">[m
[32m+[m[32m                    <input class="input_1" type="number" name="f-email" placeholder="">[m
                     <span class="grey-line"></span>[m
                     <span class="blue-line"></span>[m
                 </label>[m
[36m@@ -93,11 +93,7 @@[m
             <div class="col _s12 _m12">[m
                 <label>Pays* :[m
                     <SELECT name="nom" size="1">[m
[31m-                        <OPTION>France métropolitaine[m
[31m-                        <OPTION>Belgique[m
[31m-                        <OPTION>Dom-Tom[m
[31m-                        <OPTION>Luxembourg[m
[31m-                        <OPTION>Suisse[m
[32m+[m[32m                        <OPTION>France[m
                     </SELECT>[m
                 </label>[m
             </div>[m
[1mdiff --git a/src/app/adress/adress.component.scss b/src/app/adress/adress.component.scss[m
[1mindex dde93d8..7e648f7 100644[m
[1m--- a/src/app/adress/adress.component.scss[m
[1m+++ b/src/app/adress/adress.component.scss[m
[36m@@ -61,7 +61,7 @@[m [mform{[m
 label{[m
   font-weight: bold;[m
   display:block;[m
[31m-  color: #49E;[m
[32m+[m[32m  color: #2fdab8;[m
   padding-bottom: 5px;[m
   width: 100%;[m
   margin: 0 auto;[m
[36m@@ -141,7 +141,6 @@[m [mlabel{[m
 }[m
 .input_1:invalid ~ .blue-line:after,[m
 .input_1.isUnvalid ~ .blue-line:after{[m
[31m-  content: '!';[m
   position: absolute;[m
   top: -28px;[m
   left: -12px;[m
[36m@@ -379,7 +378,7 @@[m [mselect:focus{[m
   background-color: #2fdab8;[m
   border: 1px solid transparent;[m
   border-radius: 2px;[m
[31m-  font-size: 18px;[m
[32m+[m[32m  font-size: 15px;[m
   font-weight: 400;[m
   color: #fafafa;[m
   text-decoration: none;[m
[36m@@ -390,7 +389,7 @@[m [mselect:focus{[m
   }[m
   &:hover{[m
     background-color: #2fdab8;[m
[31m-    font-size: 20px;[m
[32m+[m[32m    font-size: 16px;[m
 [m
   }[m
 [m

[33mcommit 9ece36a103350c83dd2b2d0f981889fde544ea6c[m
Merge: 2e724c3 0a325f0
Author: pophamdi <pophamdi@gmail.com>
Date:   Sat May 5 15:24:26 2018 +0100

    fix merge

[33mcommit 0a325f0951f1133c637dd7878129cb7c9121fd34[m
Author: Nouha <nouha.bensalem1992@gmail.com>
Date:   Sat May 5 15:15:40 2018 +0100

    update the adress delevery style

[1mdiff --git a/src/app/adress/adress.component.html b/src/app/adress/adress.component.html[m
[1mindex bfe3c51..025fd2b 100644[m
[1m--- a/src/app/adress/adress.component.html[m
[1m+++ b/src/app/adress/adress.component.html[m
[36m@@ -29,23 +29,8 @@[m
 <!--breadcrump end-->[m
 [m
 <!--form Start-->[m
[31m-[m
[31m-<!--[m
[31m-<form>[m
[31m-    <label>pays</label>[m
[31m-    <select>[m
[31m-        <option>France</option>[m
[31m-    </select>[m
[31m-[m
[31m-    <label>ligne d'adresse</label>[m
[31m-    <textarea></textarea>[m
[31m-    [m
[31m-</form>[m
[31m--->[m
[31m-[m
 <div class="content">[m
     <form method="post" action="#" class="forms">[m
[31m-[m
         <div class="row">[m
             <h2>CREATION D'UNE ADRESSE DE LIVRAISON</h2>[m
             <br>[m
[36m@@ -64,8 +49,6 @@[m
                     <span class="blue-line"></span>[m
                 </label>[m
             </div>[m
[31m-[m
[31m-[m
             <div class="col _s12 _m12">[m
                 <label>Télephone* :[m
                     <input class="input_1" type="number" name="f-email" placeholder="06 01 02 03 04">[m
[36m@@ -133,30 +116,3 @@[m
         </div>[m
     </form>[m
 </div>[m
[31m-[m
[31m-<script>[m
[31m-    $(function() {[m
[31m-[m
[31m-        $( ".input_1[required]" ).change(function() {[m
[31m-            if($(this).val() != ""){[m
[31m-                $(this).addClass("isValid");[m
[31m-                $(this).removeClass("isUnvalid");[m
[31m-            }[m
[31m-            else{[m
[31m-                $(this).removeClass("isValid");[m
[31m-                $(this).addClass("isUnvalid");[m
[31m-            }[m
[31m-        });[m
[31m-        $( ".input_1" ).change(function() {[m
[31m-            if($(this).val() != ""){[m
[31m-                $(this).addClass("isValid");[m
[31m-            }[m
[31m-            else{[m
[31m-                $(this).removeClass("isValid");[m
[31m-            }[m
[31m-        });[m
[31m-[m
[31m-    });[m
[31m-[m
[31m-[m
[31m-</script>[m
\ No newline at end of file[m

[33mcommit 4ea8cf1cc601e934e1a08fd91751a9d0b915508e[m
Author: Nouha <nouha.bensalem1992@gmail.com>
Date:   Sat May 5 15:11:28 2018 +0100

    fix the style address

[1mdiff --git a/src/app/adress/adress.component.html b/src/app/adress/adress.component.html[m
[1mindex 5dbb06b..bfe3c51 100644[m
[1m--- a/src/app/adress/adress.component.html[m
[1m+++ b/src/app/adress/adress.component.html[m
[36m@@ -29,6 +29,8 @@[m
 <!--breadcrump end-->[m
 [m
 <!--form Start-->[m
[32m+[m
[32m+[m[32m<!--[m
 <form>[m
     <label>pays</label>[m
     <select>[m
[36m@@ -38,4 +40,123 @@[m
     <label>ligne d'adresse</label>[m
     <textarea></textarea>[m
     [m
[31m-</form>[m
\ No newline at end of file[m
[32m+[m[32m</form>[m
[32m+[m[32m-->[m
[32m+[m
[32m+[m[32m<div class="content">[m
[32m+[m[32m    <form method="post" action="#" class="forms">[m
[32m+[m
[32m+[m[32m        <div class="row">[m
[32m+[m[32m            <h2>CREATION D'UNE ADRESSE DE LIVRAISON</h2>[m
[32m+[m[32m            <br>[m
[32m+[m[32m            <h3>Informations</h3>[m
[32m+[m[32m            <div class="col _s12 _m6">[m
[32m+[m[32m                <label>Prénom* :[m
[32m+[m[32m                    <input class="input_1" type="text" name="f-name" placeholder="Prénom" required>[m
[32m+[m[32m                    <span class="grey-line"></span>[m
[32m+[m[32m                    <span class="blue-line"></span>[m
[32m+[m[32m                </label>[m
[32m+[m[32m            </div>[m
[32m+[m[32m            <div class="col _s12 _m6">[m
[32m+[m[32m                <label>Nom* :[m
[32m+[m[32m                    <input class="input_1" type="text" name="f-name" placeholder="Nom" required>[m
[32m+[m[32m                    <span class="grey-line"></span>[m
[32m+[m[32m                    <span class="blue-line"></span>[m
[32m+[m[32m                </label>[m
[32m+[m[32m            </div>[m
[32m+[m
[32m+[m
[32m+[m[32m            <div class="col _s12 _m12">[m
[32m+[m[32m                <label>Télephone* :[m
[32m+[m[32m                    <input class="input_1" type="number" name="f-email" placeholder="06 01 02 03 04">[m
[32m+[m[32m                    <span class="grey-line"></span>[m
[32m+[m[32m                    <span class="blue-line"></span>[m
[32m+[m[32m                </label>[m
[32m+[m[32m            </div>[m
[32m+[m[32m        </div>[m
[32m+[m[32m        <div class="row">[m
[32m+[m[32m            <h3>Adresse de livraison</h3>[m
[32m+[m[32m            <div class="col _s12 _m12">[m
[32m+[m[32m                <label>Donner un nom à cette adresse* :[m
[32m+[m[32m                    <input class="input_1" type="text" name="f-email" placeholder="Bureau, maison ...">[m
[32m+[m[32m                    <span class="grey-line"></span>[m
[32m+[m[32m                    <span class="blue-line"></span>[m
[32m+[m[32m                </label>[m
[32m+[m[32m            </div>[m
[32m+[m[32m            <div class="col _s12 _m12">[m
[32m+[m[32m                <label>Adresse* :[m
[32m+[m[32m                    <input class="input_1" type="text" name="f-email" placeholder="Rue, numéro, étage,...">[m
[32m+[m[32m                    <span class="grey-line"></span>[m
[32m+[m[32m                    <span class="blue-line"></span>[m
[32m+[m[32m                </label>[m
[32m+[m
[32m+[m[32m            </div>[m
[32m+[m[32m            <div class="col _s12 _m6">[m
[32m+[m[32m                <label>Code postal* :[m
[32m+[m[32m                    <input class="input_1" type="number" name="f-email" placeholder="12345">[m
[32m+[m[32m                    <span class="grey-line"></span>[m
[32m+[m[32m                    <span class="blue-line"></span>[m
[32m+[m[32m                </label>[m
[32m+[m[32m            </div>[m
[32m+[m[32m            <div class="col _s12 _m6">[m
[32m+[m[32m                <label>Ville* :[m
[32m+[m[32m                    <input class="input_1" type="text" name="f-email" placeholder="Ville">[m
[32m+[m[32m                    <span class="grey-line"></span>[m
[32m+[m[32m                    <span class="blue-line"></span>[m
[32m+[m
[32m+[m[32m                </label>[m
[32m+[m[32m            </div>[m
[32m+[m
[32m+[m[32m            <div class="col _s12 _m12">[m
[32m+[m[32m                <label>Pays* :[m
[32m+[m[32m                    <SELECT name="nom" size="1">[m
[32m+[m[32m                        <OPTION>France métropolitaine[m
[32m+[m[32m                        <OPTION>Belgique[m
[32m+[m[32m                        <OPTION>Dom-Tom[m
[32m+[m[32m                        <OPTION>Luxembourg[m
[32m+[m[32m                        <OPTION>Suisse[m
[32m+[m[32m                    </SELECT>[m
[32m+[m[32m                </label>[m
[32m+[m[32m            </div>[m
[32m+[m[32m        </div>[m
[32m+[m
[32m+[m[32m        <div class="row">[m
[32m+[m[32m            <div class="r-field col _s12 _m12">[m
[32m+[m[32m                <p>* Champs obligatoires</p>[m
[32m+[m[32m            </div>[m
[32m+[m[32m        </div>[m
[32m+[m
[32m+[m[32m        <div class="row">[m
[32m+[m[32m            <div class="col-md-offset-8">[m
[32m+[m[32m                <a href="#" class="button">Valider cette adresse</a>[m
[32m+[m[32m            </div>[m
[32m+[m[32m        </div>[m
[32m+[m[32m    </form>[m
[32m+[m[32m</div>[m
[32m+[m
[32m+[m[32m<script>[m
[32m+[m[32m    $(function() {[m
[32m+[m
[32m+[m[32m        $( ".input_1[required]" ).change(function() {[m
[32m+[m[32m            if($(this).val() != ""){[m
[32m+[m[32m                $(this).addClass("isValid");[m
[32m+[m[32m                $(this).removeClass("isUnvalid");[m
[32m+[m[32m            }[m
[32m+[m[32m            else{[m
[32m+[m[32m                $(this).removeClass("isValid");[m
[32m+[m[32m                $(this).addClass("isUnvalid");[m
[32m+[m[32m            }[m
[32m+[m[32m        });[m
[32m+[m[32m        $( ".input_1" ).change(function() {[m
[32m+[m[32m            if($(this).val() != ""){[m
[32m+[m[32m                $(this).addClass("isValid");[m
[32m+[m[32m            }[m
[32m+[m[32m            else{[m
[32m+[m[32m                $(this).removeClass("isValid");[m
[32m+[m[32m            }[m
[32m+[m[32m        });[m
[32m+[m
[32m+[m[32m    });[m
[32m+[m
[32m+[m
[32m+[m[32m</script>[m
\ No newline at end of file[m
[1mdiff --git a/src/app/adress/adress.component.scss b/src/app/adress/adress.component.scss[m
[1mindex 9b150dd..dde93d8 100644[m
[1m--- a/src/app/adress/adress.component.scss[m
[1m+++ b/src/app/adress/adress.component.scss[m
[36m@@ -19,4 +19,979 @@[m
 .bs-wizard > .bs-wizard-step.disabled > .bs-wizard-dot:after {opacity: 0;}[m
 .bs-wizard > .bs-wizard-step:first-child  > .progress {left: 50%; width: 50%;}[m
 .bs-wizard > .bs-wizard-step:last-child  > .progress {width: 50%;}[m
[31m-.bs-wizard > .bs-wizard-step.disabled a.bs-wizard-dot{ pointer-events: none; }[m
\ No newline at end of file[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.disabled a.bs-wizard-dot{ pointer-events: none; }[m
[32m+[m
[32m+[m[32m/* form style */[m
[32m+[m[32m*{[m
[32m+[m[32m  -webkit-box-sizing: border-box; /* Safari/Chrome, other WebKit */[m
[32m+[m[32m  -moz-box-sizing: border-box;    /* Firefox, other Gecko */[m
[32m+[m[32m  box-sizing: border-box;[m
[32m+[m[32m  font-family: "Open Sans";[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mh3{[m
[32m+[m[32m  font-weight: 300;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.r-field{[m
[32m+[m[32m  font-weight: 400;[m
[32m+[m[32m  font-size: 12px;[m
[32m+[m[32m  color: #111111;[m
[32m+[m[32m}[m
[32m+[m[32m.content{[m
[32m+[m[32m  width: 50%;[m
[32m+[m[32m  margin: 0 auto;[m
[32m+[m[32m}[m
[32m+[m[32m@media (max-width: 800px) {[m
[32m+[m[32m  .content{[m
[32m+[m[32m    width: 100%;[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m[32mform{[m
[32m+[m[32m  -webkit-box-sizing: border-box; /* Safari/Chrome, other WebKit */[m
[32m+[m[32m  -moz-box-sizing: border-box;    /* Firefox, other Gecko */[m
[32m+[m[32m  box-sizing: border-box;[m
[32m+[m[32m  font-family:"Pt sans";[m
[32m+[m
[32m+[m[32m  position:relative;[m
[32m+[m[32m  width: 100%;[m
[32m+[m[32m  margin: 0 auto;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mlabel{[m
[32m+[m[32m  font-weight: bold;[m
[32m+[m[32m  display:block;[m
[32m+[m[32m  color: #49E;[m
[32m+[m[32m  padding-bottom: 5px;[m
[32m+[m[32m  width: 100%;[m
[32m+[m[32m  margin: 0 auto;[m
[32m+[m[32m  position: relative;[m
[32m+[m[32m  margin-bottom:5px;[m
[32m+[m[32m  font-weight:400;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.input_1{[m
[32m+[m[32m  width: 100%;[m
[32m+[m[32m  height: 28px;[m
[32m+[m[32m  border: none;[m
[32m+[m[32m  background-color: #ECECEC;[m
[32m+[m[32m  padding-left: 10px;[m
[32m+[m[32m  box-shadow: none;[m
[32m+[m[32m  outline: none;[m
[32m+[m[32m  position: relative;[m
[32m+[m[32m  display:block;[m
[32m+[m[32m  -webkit-box-sizing: border-box; /* Safari/Chrome, other WebKit */[m
[32m+[m[32m  -moz-box-sizing: border-box;    /* Firefox, other Gecko */[m
[32m+[m[32m  box-sizing: border-box;[m
[32m+[m
[32m+[m[32m  margin-top:10px;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.blue-line-left{[m
[32m+[m
[32m+[m[32m  background: #49E;[m
[32m+[m[32m  position: absolute;[m
[32m+[m[32m  left: -1px;[m
[32m+[m[32m  width: 1px;[m
[32m+[m[32m  height: 28px;[m
[32m+[m[32m  bottom:5px;[m
[32m+[m[32m  transition: all .2s;[m
[32m+[m[32m  -webkit-box-sizing: border-box; /* Safari/Chrome, other WebKit */[m
[32m+[m[32m  -moz-box-sizing: border-box;    /* Firefox, other Gecko */[m
[32m+[m[32m  box-sizing: border-box;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m
[32m+[m[32m.blue-line {[m
[32m+[m[32m  display: block;[m
[32m+[m[32m  width: 0;[m
[32m+[m[32m  height: 1px;[m
[32m+[m[32m  background: #49E;[m
[32m+[m[32m  position: absolute;[m
[32m+[m
[32m+[m[32m  transition: all .2s;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.input_1:focus ~ .blue-line{[m
[32m+[m[32m  width: 100%;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.input_1:focus + .blue-line-left{[m
[32m+[m[32m  height: 0;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.grey-line {[m
[32m+[m[32m  display: block;[m
[32m+[m[32m  width: 0;[m
[32m+[m[32m  height: 1px;[m
[32m+[m[32m  background: #ccc;[m
[32m+[m[32m  position: absolute;[m
[32m+[m[32m  transition: all .2s;[m
[32m+[m[32m}[m
[32m+[m[32m.input_1:hover ~ .grey-line {[m
[32m+[m[32m  width: 100%;[m
[32m+[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.input_1:invalid ~ .blue-line,[m
[32m+[m[32m.input_1.isUnvalid ~ .blue-line{[m
[32m+[m[32m  width: 100%;[m
[32m+[m[32m  height: 2px;[m
[32m+[m[32m  background-color: #F70600;[m
[32m+[m[32m}[m
[32m+[m[32m.input_1:invalid ~ .blue-line:after,[m
[32m+[m[32m.input_1.isUnvalid ~ .blue-line:after{[m
[32m+[m[32m  content: '!';[m
[32m+[m[32m  position: absolute;[m
[32m+[m[32m  top: -28px;[m
[32m+[m[32m  left: -12px;[m
[32m+[m[32m  font-size: 20px;[m
[32m+[m[32m  color: #F70600;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.input_1.isValid ~ .blue-line{[m
[32m+[m[32m  width: 100%;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m
[32m+[m[32m.field-icon{[m
[32m+[m[32m  position: absolute;[m
[32m+[m[32m  padding-left: 6px;[m
[32m+[m[32m  font-size: 18px;[m
[32m+[m[32m  padding-top: 2px;[m
[32m+[m[32m  color: #929292;[m
[32m+[m[32m  pointer-events: none;[m
[32m+[m[32m  left: 0;[m
[32m+[m[32m  z-index: 2;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.content-input-icon input{[m
[32m+[m[32m  padding-left: 28px;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32mtextarea{[m
[32m+[m[32m  position: relative;[m
[32m+[m[32m  display:block;[m
[32m+[m[32m  width: 100%;[m
[32m+[m[32m  border: 1px solid transparent;[m
[32m+[m[32m  background-color: #ECECEC;[m
[32m+[m[32m  resize: none;[m
[32m+[m[32m  font-size: 14px;[m
[32m+[m[32m}[m
[32m+[m[32mtextarea:hover{[m
[32m+[m[32m  border-color: #ddd;[m
[32m+[m[32m}[m
[32m+[m[32mtextarea:focus{[m
[32m+[m[32m  border-color: #49E;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m
[32m+[m[32mselect{[m
[32m+[m[32m  position: relative;[m
[32m+[m[32m  display:block;[m
[32m+[m[32m  margin-top:10px;[m
[32m+[m[32m  height: 28px;[m
[32m+[m[32m  width:100%;[m
[32m+[m[32m  border: 1px solid transparent;[m
[32m+[m[32m  background-color: #ECECEC;[m
[32m+[m[32m  box-shadow: none;[m
[32m+[m[32m}[m
[32m+[m[32mselect:hover{[m
[32m+[m[32m  border-color: #ccc;[m
[32m+[m[32m}[m
[32m+[m[32mselect:focus{[m
[32m+[m[32m  border-color: #49E;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.checkbox{[m
[32m+[m[32m  font-size: 14px;[m
[32m+[m[32m}[m
[32m+[m[32m.checkbox ul{[m
[32m+[m[32m  list-style-type: none;[m
[32m+[m[32m  margin: 0;[m
[32m+[m[32m  padding: 0;[m
[32m+[m[32m}[m
[32m+[m[32m.checkbox ul li{[m
[32m+[m[32m  margin-bottom: 12px;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.checkbox input{[m
[32m+[m[32m  display: inline;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.checkbox label{[m
[32m+[m[32m  display: inline;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m[type="checkbox"]{[m
[32m+[m[32m  position: absolute;[m
[32m+[m[32m  left: -9999px;[m
[32m+[m[32m}[m
[32m+[m[32m[type="checkbox"] + label,[m
[32m+[m[32m[type="checkbox"]:checked + label {[m
[32m+[m[32m  position: relative;[m
[32m+[m[32m  padding-left: 25px;[m
[32m+[m[32m  cursor: pointer;[m
[32m+[m[32m}[m
[32m+[m[32m[type="checkbox"] + label:before,[m
[32m+[m[32m[type="checkbox"]:checked + label:before {[m
[32m+[m[32m  content: '';[m
[32m+[m[32m  position: absolute;[m
[32m+[m[32m  left:0; top: -1px;[m
[32m+[m[32m  width: 17px; height: 17px;[m
[32m+[m[32m  border: 1px solid #bbb;[m
[32m+[m[32m  background: #fff;[m
[32m+[m[32m  border-radius: 2px;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m[type="checkbox"] + label:after,[m
[32m+[m[32m[type="checkbox"]:checked + label:after {[m
[32m+[m[32m  content: '✔';[m
[32m+[m[32m  position: absolute;[m
[32m+[m[32m  top: 2px; left: 3px;[m
[32m+[m[32m  font-size: 19px;[m
[32m+[m[32m  line-height: 0.8;[m
[32m+[m[32m  color: #49E;[m
[32m+[m[32m  transition: all .2s;[m
[32m+[m[32m}[m
[32m+[m[32m[type="checkbox"] + label:after {[m
[32m+[m[32m  opacity: 0;[m
[32m+[m[32m  transform: scale(0);[m
[32m+[m[32m}[m
[32m+[m[32m[type="checkbox"]:checked + label:after {[m
[32m+[m[32m  opacity: 1;[m
[32m+[m[32m  transform: scale(1);[m
[32m+[m[32m}[m
[32m+[m[32m/* disabled checkbox */[m
[32m+[m[32m[type="checkbox"]:disabled + label:before,[m
[32m+[m[32m[type="checkbox"]:disabled:checked + label:before {[m
[32m+[m[32m  border-color: #bbb;[m
[32m+[m[32m  background-color: #ddd;[m
[32m+[m[32m}[m
[32m+[m[32m[type="checkbox"]:disabled:checked + label:after {[m
[32m+[m[32m  color: #919191;[m
[32m+[m[32m}[m
[32m+[m[32m[type="checkbox"]:disabled + label {[m
[32m+[m[32m  color: #919191;[m
[32m+[m[32m}[m
[32m+[m[32m[type="checkbox"]:checked:focus + label:before,[m
[32m+[m[32m[type="checkbox"]:focus + label:before {[m
[32m+[m[32m  border: 1px dotted #49E;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.checkbox label:hover:before {[m
[32m+[m[32m  border: 1px solid #4778d9!important;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.radios ul{[m
[32m+[m[32m  list-style: none;[m
[32m+[m[32m  height: 100%;[m
[32m+[m[32m  width: 100%;[m
[32m+[m[32m  margin: 0;[m
[32m+[m[32m  padding: 0;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.radios label{[m
[32m+[m[32m  color : #7A7A7A;[m
[32m+[m[32m}[m
[32m+[m[32m.radios ul li{[m
[32m+[m[32m  color: #AAAAAA;[m
[32m+[m[32m  display: block;[m
[32m+[m[32m  position: relative;[m
[32m+[m[32m  width: 100%;[m
[32m+[m[32m  margin-bottom: 8px;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.radios ul li input[type=radio]{[m
[32m+[m[32m  position: absolute;[m
[32m+[m[32m  visibility: hidden;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.radios ul li label{[m
[32m+[m[32m  display: block;[m
[32m+[m[32m  display: inline-block;[m
[32m+[m[32m  position: relative;[m
[32m+[m[32m  font-weight: 400;[m
[32m+[m[32m  font-size: 14px;[m
[32m+[m[32m  padding: 0px 0px 0px 25px;[m
[32m+[m[32m  margin: 0;[m
[32m+[m[32m  z-index: 9;[m
[32m+[m[32m  cursor: pointer;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.radios ul li:hover label{[m
[32m+[m[32m  color: #49E;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.radios ul li .check{[m
[32m+[m[32m  display: inline-block;[m
[32m+[m[32m  position: absolute;[m
[32m+[m[32m  border: 2px solid #AAAAAA;[m
[32m+[m[32m  border-radius: 100%;[m
[32m+[m[32m  height: 16px;[m
[32m+[m[32m  width: 16px;[m
[32m+[m[32m  top: 5px;[m
[32m+[m[32m  left: 0px;[m
[32m+[m[32m  z-index: 5;[m
[32m+[m[32m  transition: border .2s linear;[m
[32m+[m[32m  -webkit-transition: border .2s linear;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.radios ul li:hover .check {[m
[32m+[m[32m  border: 2px solid #49E;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.radios ul li .check::before {[m
[32m+[m[32m  display: block;[m
[32m+[m[32m  position: absolute;[m
[32m+[m[32m  content: '';[m
[32m+[m[32m  border-radius: 100%;[m
[32m+[m[32m  height: 8px;[m
[32m+[m[32m  width: 8px;[m
[32m+[m[32m  top: 2px;[m
[32m+[m[32m  left: 2px;[m
[32m+[m[32m  margin: auto;[m
[32m+[m[32m  transition: background 0.2s linear;[m
[32m+[m[32m  -webkit-transition: background 0.2s linear;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.radios input[type=radio]:checked ~ .check {[m
[32m+[m[32m  border: 2px solid #49E;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.radios input[type=radio]:checked ~ .check::before{[m
[32m+[m[32m  background: #49E;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.radios input[type=radio]:checked ~ label{[m
[32m+[m[32m  color: #49E;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m
[32m+[m[32m.button{[m
[32m+[m[32m  position:relative;[m
[32m+[m[32m  display:inline-block;[m
[32m+[m[32m  margin-top: 15px;[m
[32m+[m[32m  padding-left: 40px;[m
[32m+[m[32m  padding-right: 40px;[m
[32m+[m[32m  padding-top: 10px;[m
[32m+[m[32m  padding-bottom: 10px;[m
[32m+[m[32m  background-color: #2fdab8;[m
[32m+[m[32m  border: 1px solid transparent;[m
[32m+[m[32m  border-radius: 2px;[m
[32m+[m[32m  font-size: 18px;[m
[32m+[m[32m  font-weight: 400;[m
[32m+[m[32m  color: #fafafa;[m
[32m+[m[32m  text-decoration: none;[m
[32m+[m[32m  transition: all 0.2s ease;[m
[32m+[m[32m  &.round{[m
[32m+[m[32m    border-radius: 25px;[m
[32m+[m[32m    border: none;[m
[32m+[m[32m  }[m
[32m+[m[32m  &:hover{[m
[32m+[m[32m    background-color: #2fdab8;[m
[32m+[m[32m    font-size: 20px;[m
[32m+[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m}[m
[32m+[m
[32m+[m
[32m+[m[32m.container {[m
[32m+[m[32m  margin: 0 auto;[m
[32m+[m[32m  max-width: 1280px;[m
[32m+[m[32m  width: 90%;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m@media only screen and (min-width: 601px) {[m
[32m+[m[32m  .container {[m
[32m+[m[32m    width: 85%;[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m[32m@media only screen and (min-width: 993px) {[m
[32m+[m[32m  .container {[m
[32m+[m[32m    width: 70%;[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m[32m.container .row {[m
[32m+[m[32m  margin-left: -0.75rem;[m
[32m+[m[32m  margin-right: -0.75rem;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.section {[m
[32m+[m[32m  padding-top: 1rem;[m
[32m+[m[32m  padding-bottom: 1rem;[m
[32m+[m[32m}[m
[32m+[m[32m.section.no-pad {[m
[32m+[m[32m  padding: 0;[m
[32m+[m[32m}[m
[32m+[m[32m.section.no-pad-bot {[m
[32m+[m[32m  padding-bottom: 0;[m
[32m+[m[32m}[m
[32m+[m[32m.section.no-pad-top {[m
[32m+[m[32m  padding-top: 0;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.row {[m
[32m+[m[32m  margin-left: auto;[m
[32m+[m[32m  margin-right: auto;[m
[32m+[m[32m  margin-bottom: 20px;[m
[32m+[m[32m}[m
[32m+[m[32m.row:after {[m
[32m+[m[32m  content: "";[m
[32m+[m[32m  display: table;[m
[32m+[m[32m  clear: both;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col {[m
[32m+[m[32m  float: left;[m
[32m+[m[32m  box-sizing: border-box;[m
[32m+[m[32m  padding: 0 0.75rem;[m
[32m+[m[32m  min-height: 1px;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col[class*="push-"], .row .col[class*="pull-"] {[m
[32m+[m[32m  position: relative;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._s1 {[m
[32m+[m[32m  width: 8.33333333%;[m
[32m+[m[32m  margin-left: auto;[m
[32m+[m[32m  left: auto;[m
[32m+[m[32m  right: auto;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._s2 {[m
[32m+[m[32m  width: 16.66666667%;[m
[32m+[m[32m  margin-left: auto;[m
[32m+[m[32m  left: auto;[m
[32m+[m[32m  right: auto;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._s3 {[m
[32m+[m[32m  width: 25%;[m
[32m+[m[32m  margin-left: auto;[m
[32m+[m[32m  left: auto;[m
[32m+[m[32m  right: auto;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._s4 {[m
[32m+[m[32m  width: 33.33333333%;[m
[32m+[m[32m  margin-left: auto;[m
[32m+[m[32m  left: auto;[m
[32m+[m[32m  right: auto;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._s5 {[m
[32m+[m[32m  width: 41.66666667%;[m
[32m+[m[32m  margin-left: auto;[m
[32m+[m[32m  left: auto;[m
[32m+[m[32m  right: auto;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._s6 {[m
[32m+[m[32m  width: 50%;[m
[32m+[m[32m  margin-left: auto;[m
[32m+[m[32m  left: auto;[m
[32m+[m[32m  right: auto;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._s7 {[m
[32m+[m[32m  width: 58.33333333%;[m
[32m+[m[32m  margin-left: auto;[m
[32m+[m[32m  left: auto;[m
[32m+[m[32m  right: auto;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._s8 {[m
[32m+[m[32m  width: 66.66666667%;[m
[32m+[m[32m  margin-left: auto;[m
[32m+[m[32m  left: auto;[m
[32m+[m[32m  right: auto;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._s9 {[m
[32m+[m[32m  width: 75%;[m
[32m+[m[32m  margin-left: auto;[m
[32m+[m[32m  left: auto;[m
[32m+[m[32m  right: auto;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._s10 {[m
[32m+[m[32m  width: 83.33333333%;[m
[32m+[m[32m  margin-left: auto;[m
[32m+[m[32m  left: auto;[m
[32m+[m[32m  right: auto;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._s11 {[m
[32m+[m[32m  width: 91.66666667%;[m
[32m+[m[32m  margin-left: auto;[m
[32m+[m[32m  left: auto;[m
[32m+[m[32m  right: auto;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._s12 {[m
[32m+[m[32m  width: 100%;[m
[32m+[m[32m  margin-left: auto;[m
[32m+[m[32m  left: auto;[m
[32m+[m[32m  right: auto;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._offset-s1 {[m
[32m+[m[32m  margin-left: 8.33333333%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._pull-s1 {[m
[32m+[m[32m  right: 8.33333333%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._push-s1 {[m
[32m+[m[32m  left: 8.33333333%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._offset-s2 {[m
[32m+[m[32m  margin-left: 16.66666667%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._pull-s2 {[m
[32m+[m[32m  right: 16.66666667%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._push-s2 {[m
[32m+[m[32m  left: 16.66666667%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._offset-s3 {[m
[32m+[m[32m  margin-left: 25%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._pull-s3 {[m
[32m+[m[32m  right: 25%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._push-s3 {[m
[32m+[m[32m  left: 25%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._offset-s4 {[m
[32m+[m[32m  margin-left: 33.33333333%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._pull-s4 {[m
[32m+[m[32m  right: 33.33333333%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._push-s4 {[m
[32m+[m[32m  left: 33.33333333%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._offset-s5 {[m
[32m+[m[32m  margin-left: 41.66666667%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._pull-s5 {[m
[32m+[m[32m  right: 41.66666667%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._push-s5 {[m
[32m+[m[32m  left: 41.66666667%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._offset-s6 {[m
[32m+[m[32m  margin-left: 50%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._pull-s6 {[m
[32m+[m[32m  right: 50%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._push-s6 {[m
[32m+[m[32m  left: 50%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._offset-s7 {[m
[32m+[m[32m  margin-left: 58.33333333%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._pull-s7 {[m
[32m+[m[32m  right: 58.33333333%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._push-s7 {[m
[32m+[m[32m  left: 58.33333333%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._offset-s8 {[m
[32m+[m[32m  margin-left: 66.66666667%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._pull-s8 {[m
[32m+[m[32m  right: 66.66666667%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._push-s8 {[m
[32m+[m[32m  left: 66.66666667%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._offset-s9 {[m
[32m+[m[32m  margin-left: 75%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._pull-s9 {[m
[32m+[m[32m  right: 75%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._push-s9 {[m
[32m+[m[32m  left: 75%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._offset-s10 {[m
[32m+[m[32m  margin-left: 83.33333333%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._pull-s10 {[m
[32m+[m[32m  right: 83.33333333%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._push-s10 {[m
[32m+[m[32m  left: 83.33333333%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._offset-s11 {[m
[32m+[m[32m  margin-left: 91.66666667%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._pull-s11 {[m
[32m+[m[32m  right: 91.66666667%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._push-s11 {[m
[32m+[m[32m  left: 91.66666667%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._offset-s12 {[m
[32m+[m[32m  margin-left: 100%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._pull-s12 {[m
[32m+[m[32m  right: 100%;[m
[32m+[m[32m}[m
[32m+[m[32m.row .col._push-s12 {[m
[32m+[m[32m  left: 100%;[m
[32m+[m[32m}[m
[32m+[m[32m@media only screen and (min-width: 601px) {[m
[32m+[m[32m  .row .col._m1 {[m
[32m+[m[32m    width: 8.33333333%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._m2 {[m
[32m+[m[32m    width: 16.66666667%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._m3 {[m
[32m+[m[32m    width: 25%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._m4 {[m
[32m+[m[32m    width: 33.33333333%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._m5 {[m
[32m+[m[32m    width: 41.66666667%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._m6 {[m
[32m+[m[32m    width: 50%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._m7 {[m
[32m+[m[32m    width: 58.33333333%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._m8 {[m
[32m+[m[32m    width: 66.66666667%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._m9 {[m
[32m+[m[32m    width: 75%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._m10 {[m
[32m+[m[32m    width: 83.33333333%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._m11 {[m
[32m+[m[32m    width: 91.66666667%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._m12 {[m
[32m+[m[32m    width: 100%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-m1 {[m
[32m+[m[32m    margin-left: 8.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-m1 {[m
[32m+[m[32m    right: 8.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-m1 {[m
[32m+[m[32m    left: 8.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-m2 {[m
[32m+[m[32m    margin-left: 16.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-m2 {[m
[32m+[m[32m    right: 16.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-m2 {[m
[32m+[m[32m    left: 16.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-m3 {[m
[32m+[m[32m    margin-left: 25%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-m3 {[m
[32m+[m[32m    right: 25%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-m3 {[m
[32m+[m[32m    left: 25%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-m4 {[m
[32m+[m[32m    margin-left: 33.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-m4 {[m
[32m+[m[32m    right: 33.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-m4 {[m
[32m+[m[32m    left: 33.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-m5 {[m
[32m+[m[32m    margin-left: 41.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-m5 {[m
[32m+[m[32m    right: 41.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-m5 {[m
[32m+[m[32m    left: 41.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-m6 {[m
[32m+[m[32m    margin-left: 50%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-m6 {[m
[32m+[m[32m    right: 50%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-m6 {[m
[32m+[m[32m    left: 50%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-m7 {[m
[32m+[m[32m    margin-left: 58.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-m7 {[m
[32m+[m[32m    right: 58.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-m7 {[m
[32m+[m[32m    left: 58.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-m8 {[m
[32m+[m[32m    margin-left: 66.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-m8 {[m
[32m+[m[32m    right: 66.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-m8 {[m
[32m+[m[32m    left: 66.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-m9 {[m
[32m+[m[32m    margin-left: 75%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-m9 {[m
[32m+[m[32m    right: 75%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-m9 {[m
[32m+[m[32m    left: 75%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-m10 {[m
[32m+[m[32m    margin-left: 83.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-m10 {[m
[32m+[m[32m    right: 83.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-m10 {[m
[32m+[m[32m    left: 83.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-m11 {[m
[32m+[m[32m    margin-left: 91.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-m11 {[m
[32m+[m[32m    right: 91.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-m11 {[m
[32m+[m[32m    left: 91.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-m12 {[m
[32m+[m[32m    margin-left: 100%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-m12 {[m
[32m+[m[32m    right: 100%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-m12 {[m
[32m+[m[32m    left: 100%;[m
[32m+[m[32m  }[m
[32m+[m[32m}[m
[32m+[m[32m@media only screen and (min-width: 993px) {[m
[32m+[m[32m  .row .col._l1 {[m
[32m+[m[32m    width: 8.33333333%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._l2 {[m
[32m+[m[32m    width: 16.66666667%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._l3 {[m
[32m+[m[32m    width: 25%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._l4 {[m
[32m+[m[32m    width: 33.33333333%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._l5 {[m
[32m+[m[32m    width: 41.66666667%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._l6 {[m
[32m+[m[32m    width: 50%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._l7 {[m
[32m+[m[32m    width: 58.33333333%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._l8 {[m
[32m+[m[32m    width: 66.66666667%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._l9 {[m
[32m+[m[32m    width: 75%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._l10 {[m
[32m+[m[32m    width: 83.33333333%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._l11 {[m
[32m+[m[32m    width: 91.66666667%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._l12 {[m
[32m+[m[32m    width: 100%;[m
[32m+[m[32m    margin-left: auto;[m
[32m+[m[32m    left: auto;[m
[32m+[m[32m    right: auto;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-l1 {[m
[32m+[m[32m    margin-left: 8.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-l1 {[m
[32m+[m[32m    right: 8.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-l1 {[m
[32m+[m[32m    left: 8.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-l2 {[m
[32m+[m[32m    margin-left: 16.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-l2 {[m
[32m+[m[32m    right: 16.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-l2 {[m
[32m+[m[32m    left: 16.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-l3 {[m
[32m+[m[32m    margin-left: 25%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-l3 {[m
[32m+[m[32m    right: 25%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-l3 {[m
[32m+[m[32m    left: 25%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-l4 {[m
[32m+[m[32m    margin-left: 33.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-l4 {[m
[32m+[m[32m    right: 33.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-l4 {[m
[32m+[m[32m    left: 33.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-l5 {[m
[32m+[m[32m    margin-left: 41.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-l5 {[m
[32m+[m[32m    right: 41.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-l5 {[m
[32m+[m[32m    left: 41.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-l6 {[m
[32m+[m[32m    margin-left: 50%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-l6 {[m
[32m+[m[32m    right: 50%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-l6 {[m
[32m+[m[32m    left: 50%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-l7 {[m
[32m+[m[32m    margin-left: 58.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-l7 {[m
[32m+[m[32m    right: 58.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-l7 {[m
[32m+[m[32m    left: 58.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-l8 {[m
[32m+[m[32m    margin-left: 66.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-l8 {[m
[32m+[m[32m    right: 66.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-l8 {[m
[32m+[m[32m    left: 66.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-l9 {[m
[32m+[m[32m    margin-left: 75%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-l9 {[m
[32m+[m[32m    right: 75%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-l9 {[m
[32m+[m[32m    left: 75%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-l10 {[m
[32m+[m[32m    margin-left: 83.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-l10 {[m
[32m+[m[32m    right: 83.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-l10 {[m
[32m+[m[32m    left: 83.33333333%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-l11 {[m
[32m+[m[32m    margin-left: 91.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-l11 {[m
[32m+[m[32m    right: 91.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-l11 {[m
[32m+[m[32m    left: 91.66666667%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._offset-l12 {[m
[32m+[m[32m    margin-left: 100%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._pull-l12 {[m
[32m+[m[32m    right: 100%;[m
[32m+[m[32m  }[m
[32m+[m[32m  .row .col._push-l12 {[m
[32m+[m[32m    left: 100%;[m
[32m+[m[32m  }[m
[32m+[m[32m}[m

[33mcommit 2e724c3b0635ed0dddbcb22582cbf26987c27d7b[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Sat May 5 13:56:41 2018 +0100

    create address service

[1mdiff --git a/src/app/adress/adress.component.html b/src/app/adress/adress.component.html[m
[1mindex 5dbb06b..caf594d 100644[m
[1m--- a/src/app/adress/adress.component.html[m
[1m+++ b/src/app/adress/adress.component.html[m
[36m@@ -37,5 +37,5 @@[m
 [m
     <label>ligne d'adresse</label>[m
     <textarea></textarea>[m
[31m-    [m
[32m+[m
 </form>[m
\ No newline at end of file[m
[1mdiff --git a/src/app/models/Address.model.ts b/src/app/models/Address.model.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..fcadc5a[m
[1m--- /dev/null[m
[1m+++ b/src/app/models/Address.model.ts[m
[36m@@ -0,0 +1,5 @@[m
[32m+[m[32mexport class Address {[m
[32m+[m[32m    constructor([m
[32m+[m[32m        public name: string[m
[32m+[m[32m    ) {}[m
[32m+[m[32m}[m
[1mdiff --git a/src/app/models/Order.model.ts b/src/app/models/Order.model.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..078dcb3[m
[1m--- /dev/null[m
[1m+++ b/src/app/models/Order.model.ts[m
[36m@@ -0,0 +1,5 @@[m
[32m+[m[32mexport class Order {[m
[32m+[m[32m    constructor([m
[32m+[m[32m        public name: string[m
[32m+[m[32m    ) {}[m
[32m+[m[32m}[m
[1mdiff --git a/src/app/services/address.service.ts b/src/app/services/address.service.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..8aba59d[m
[1m--- /dev/null[m
[1m+++ b/src/app/services/address.service.ts[m
[36m@@ -0,0 +1,30 @@[m
[32m+[m[32mimport { Injectable } from '@angular/core';[m
[32m+[m[32mimport {Subject} from 'rxjs/Subject';[m
[32m+[m[32mimport {HttpClient} from '@angular/common/http';[m
[32m+[m[32mimport {Order} from '../models/Order.model';[m
[32m+[m[32mimport {Address} from '../models/Address.model';[m
[32m+[m
[32m+[m[32m@Injectable()[m
[32m+[m[32mexport class AddressService {[m
[32m+[m[32m    addressSubject = new Subject<any[]>();[m
[32m+[m[32m    private addresses = [] ;[m
[32m+[m[32m    constructor(private httpClient: HttpClient) { }[m
[32m+[m[32m    public emitAddressSubject() {[m
[32m+[m[32m        this.addressSubject.next(this.addresses.slice());[m
[32m+[m[32m    }[m
[32m+[m[32m    saveToServer(body: any) {[m
[32m+[m[32m        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/customers/addresess';[m
[32m+[m[32m        const b = JSON.stringify(body);[m
[32m+[m[32m        this.httpClient.post(url, b, {[m
[32m+[m[32m            headers: {'Content-Type': 'application/json'}[m
[32m+[m[32m        })[m
[32m+[m[32m            .subscribe([m
[32m+[m[32m                () => {}, (error) => {console.log( b + 'erreur' + error); }[m
[32m+[m[32m            );[m
[32m+[m[32m    }[m
[32m+[m[32m    add(address: Address) {[m
[32m+[m[32m        this.addresses.push(address);[m
[32m+[m[32m        this.emitAddressSubject();[m
[32m+[m[32m        this.saveToServer(address);[m
[32m+[m[32m    }[m
[32m+[m[32m}[m
[1mdiff --git a/src/app/services/order.service.ts b/src/app/services/order.service.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..2cc585a[m
[1m--- /dev/null[m
[1m+++ b/src/app/services/order.service.ts[m
[36m@@ -0,0 +1,30 @@[m
[32m+[m[32mimport { Injectable } from '@angular/core';[m
[32m+[m[32mimport {Subject} from 'rxjs/Subject';[m
[32m+[m[32mimport {HttpClient} from '@angular/common/http';[m
[32m+[m[32mimport {Customer} from '../models/Customer.model';[m
[32m+[m[32mimport {Order} from '../models/Order.model';[m
[32m+[m
[32m+[m[32m@Injectable()[m
[32m+[m[32mexport class OrderService {[m
[32m+[m[32m    orderSubject = new Subject<any[]>();[m
[32m+[m[32m    private orders = [] ;[m
[32m+[m[32m    constructor(private httpClient: HttpClient) { }[m
[32m+[m[32m    public emitOrderSubject() {[m
[32m+[m[32m        this.orderSubject.next(this.orders.slice());[m
[32m+[m[32m    }[m
[32m+[m[32m    saveOrderToServer(body: any) {[m
[32m+[m[32m        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/orders';[m
[32m+[m[32m        const b = JSON.stringify(body);[m
[32m+[m[32m        this.httpClient.post(url, b, {[m
[32m+[m[32m            headers: {'Content-Type': 'application/json'}[m
[32m+[m[32m        })[m
[32m+[m[32m            .subscribe([m
[32m+[m[32m                () => {}, (error) => {console.log( b + 'erreur' + error); }[m
[32m+[m[32m            );[m
[32m+[m[32m    }[m
[32m+[m[32m    addOrder(order: Order) {[m
[32m+[m[32m        this.orders.push(order);[m
[32m+[m[32m        this.emitOrderSubject();[m
[32m+[m[32m        this.saveOrderToServer(order);[m
[32m+[m[32m    }[m
[32m+[m[32m}[m

[33mcommit 45e55fbfb15afd3b3fd59383552316c5049fe073[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Sat May 5 09:39:37 2018 +0100

    create address

[1mdiff --git a/src/app/adress/adress.component.html b/src/app/adress/adress.component.html[m
[1mnew file mode 100644[m
[1mindex 0000000..5dbb06b[m
[1m--- /dev/null[m
[1m+++ b/src/app/adress/adress.component.html[m
[36m@@ -0,0 +1,41 @@[m
[32m+[m[32m<!--breadcrump start-->[m
[32m+[m[32m<div class="row bs-wizard" style="border-bottom:0;">[m
[32m+[m
[32m+[m[32m  <div class="col-xs-3 bs-wizard-step complete">[m
[32m+[m[32m    <div class="text-center bs-wizard-stepnum">Mon panier</div>[m
[32m+[m[32m    <div class="progress"><div class="progress-bar"></div></div>[m
[32m+[m[32m    <a  class="bs-wizard-dot"></a>[m
[32m+[m
[32m+[m[32m  </div>[m
[32m+[m
[32m+[m[32m  <div class="col-xs-3 bs-wizard-step active"><!-- complete -->[m
[32m+[m[32m    <div class="text-center bs-wizard-stepnum">Livraison</div>[m
[32m+[m[32m    <div class="progress"><div class="progress-bar"></div></div>[m
[32m+[m[32m    <a href="#" class="bs-wizard-dot"></a>[m
[32m+[m[32m  </div>[m
[32m+[m
[32m+[m[32m  <div class="col-xs-3 bs-wizard-step disabled"><!-- complete -->[m
[32m+[m[32m    <div class="text-center bs-wizard-stepnum">Paiement</div>[m
[32m+[m[32m    <div class="progress"><div class="progress-bar"></div></div>[m
[32m+[m[32m    <a href="#" class="bs-wizard-dot"></a>[m
[32m+[m[32m  </div>[m
[32m+[m
[32m+[m[32m  <div class="col-xs-3 bs-wizard-step disabled"><!-- active -->[m
[32m+[m[32m    <div class="text-center bs-wizard-stepnum">Confirmation</div>[m
[32m+[m[32m    <div class="progress"><div class="progress-bar"></div></div>[m
[32m+[m[32m    <a href="#" class="bs-wizard-dot"></a>[m
[32m+[m[32m  </div>[m
[32m+[m[32m</div>[m
[32m+[m[32m<!--breadcrump end-->[m
[32m+[m
[32m+[m[32m<!--form Start-->[m
[32m+[m[32m<form>[m
[32m+[m[32m    <label>pays</label>[m
[32m+[m[32m    <select>[m
[32m+[m[32m        <option>France</option>[m
[32m+[m[32m    </select>[m
[32m+[m
[32m+[m[32m    <label>ligne d'adresse</label>[m
[32m+[m[32m    <textarea></textarea>[m
[32m+[m[41m    [m
[32m+[m[32m</form>[m
\ No newline at end of file[m
[1mdiff --git a/src/app/adress/adress.component.scss b/src/app/adress/adress.component.scss[m
[1mnew file mode 100644[m
[1mindex 0000000..9b150dd[m
[1m--- /dev/null[m
[1m+++ b/src/app/adress/adress.component.scss[m
[36m@@ -0,0 +1,22 @@[m
[32m+[m[32m/*breadcrump*/[m
[32m+[m[32m.bs-wizard {margin-top: 40px;}[m
[32m+[m
[32m+[m[32m/*Form Wizard*/[m
[32m+[m[32m.bs-wizard {border-bottom: solid 1px #e0e0e0; padding: 0 0 10px 0;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step {padding: 0; position: relative;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step + .bs-wizard-step {}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step .bs-wizard-stepnum {color: #595959; font-size: 16px; margin-bottom: 5px;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step .bs-wizard-info {color: #999; font-size: 14px;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step > .bs-wizard-dot {position: absolute; width: 30px; height: 30px; display: block; background: #fbe8aa; top: 45px; left: 50%; margin-top: -15px; margin-left: -15px; border-radius: 50%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step > .bs-wizard-dot:after {content: ' '; width: 14px; height: 14px; background: #fbbd19; border-radius: 50px; position: absolute; top: 8px; left: 8px; }[m
[32m+[m[32m.bs-wizard > .bs-wizard-step > .progress {position: relative; border-radius: 0px; height: 8px; box-shadow: none; margin: 20px 0;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step > .progress > .progress-bar {width:0px; box-shadow: none; background: #fbe8aa;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.complete > .progress > .progress-bar {width:100%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.active > .progress > .progress-bar {width:50%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step:first-child.active > .progress > .progress-bar {width:0%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step:last-child.active > .progress > .progress-bar {width: 100%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.disabled > .bs-wizard-dot {background-color: #f5f5f5;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.disabled > .bs-wizard-dot:after {opacity: 0;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step:first-child  > .progress {left: 50%; width: 50%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step:last-child  > .progress {width: 50%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.disabled a.bs-wizard-dot{ pointer-events: none; }[m
\ No newline at end of file[m
[1mdiff --git a/src/app/adress/adress.component.ts b/src/app/adress/adress.component.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..fc431ec[m
[1m--- /dev/null[m
[1m+++ b/src/app/adress/adress.component.ts[m
[36m@@ -0,0 +1,15 @@[m
[32m+[m[32mimport { Component, OnInit } from '@angular/core';[m
[32m+[m
[32m+[m[32m@Component({[m
[32m+[m[32m  selector: 'app-adress',[m
[32m+[m[32m  templateUrl: './adress.component.html',[m
[32m+[m[32m  styleUrls: ['./adress.component.scss'][m
[32m+[m[32m})[m
[32m+[m[32mexport class AdressComponent implements OnInit {[m
[32m+[m
[32m+[m[32m  constructor() { }[m
[32m+[m
[32m+[m[32m  ngOnInit() {[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m}[m
[1mdiff --git a/src/app/app.module.ts b/src/app/app.module.ts[m
[1mindex 8f436ab..d2f1e4e 100644[m
[1m--- a/src/app/app.module.ts[m
[1m+++ b/src/app/app.module.ts[m
[36m@@ -31,6 +31,7 @@[m [mimport { SigninComponent } from './signin/signin.component';[m
 import { ContainerComponent } from './container/container.component';[m
 import { CustomerProfileComponent } from './customer-profile/customer-profile.component';[m
 import { JewelryComponent } from './jewelry/jewelry.component';[m
[32m+[m[32mimport { AdressComponent } from './adress/adress.component';[m
 [m
 [m
 [m
[36m@@ -41,6 +42,7 @@[m [mconst appRoutes: Routes = [[m
     { path: '', component: HomeComponent},[m
     /*basket-list*/[m
     { path: 'basket', component: BasketListComponent},[m
[32m+[m[32m    { path: 'address', component: AdressComponent},[m
     { path: 'clothes',  component: ClothesComponent},[m
     { path: 'beauty',  component: BeautyComponent},[m
     { path: 'HighTec',  component: HighTecComponent},[m
[36m@@ -99,6 +101,7 @@[m [mconst appRoutes: Routes = [[m
     ContainerComponent,[m
     CustomerProfileComponent,[m
     JewelryComponent,[m
[32m+[m[32m    AdressComponent,[m
   ],[m
   imports: [[m
     BrowserModule,[m
[1mdiff --git a/src/app/basket-list/basket-list.component.html b/src/app/basket-list/basket-list.component.html[m
[1mindex 3b81d20..608d049 100644[m
[1m--- a/src/app/basket-list/basket-list.component.html[m
[1m+++ b/src/app/basket-list/basket-list.component.html[m
[36m@@ -79,7 +79,7 @@[m
         <div class="card-footer">[m
 [m
             <div class="pull-right" style="margin: 10px">[m
[31m-                <a  class="btn btn-success pull-right">Valider</a>[m
[32m+[m[32m                <a  class="btn btn-success pull-right" routerLink="/address" *ngIf="total !== 0">Valider</a>[m
                 <div class="pull-right" style="margin: 5px">[m
                     TOTAL: <b class="pink">{{total}} €</b>[m
                 </div>[m

[33mcommit aff38b1c321ebd2cbd1d0e97d19273901730676f[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Thu May 3 16:59:38 2018 +0100

    create profile

[1mdiff --git a/src/app/customer-profile/customer-profile.component.html b/src/app/customer-profile/customer-profile.component.html[m
[1mindex ceafae9..b0d3185 100644[m
[1m--- a/src/app/customer-profile/customer-profile.component.html[m
[1m+++ b/src/app/customer-profile/customer-profile.component.html[m
[36m@@ -51,57 +51,80 @@[m
                             <label for="tel">Numéro de télephone* :</label>[m
                             <span></span>[m
                         </div>[m
[31m-                        <div class="styled-input">[m
[31m-                            <select formControlName="sex" class="form-control form-control-sm">[m
[31m-                                <option value="Homme" selected>Homme</option>[m
[31m-                                <option value="Femme">Femme</option>[m
[31m-                            </select>[m
[31m-                        </div>[m
[32m+[m
                         <input type="submit" value="Modifier" [disabled]="customerForm.invalid">[m
                     </form>[m
                 </div>[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
                 <div class="col-md-6 contact-form">[m
                     <h4 class="white-w3ls">Mon adresse  <span>Email</span></h4>[m
[31m-                    <form  [formGroup]="customerForm" (ngSubmit)="onSubmitForm()">[m
[32m+[m
[32m+[m[32m                    <form  [formGroup]="emailForm" (ngSubmit)="onSubmitEmailForm()">[m
[32m+[m
                         <div class="styled-input agile-styled-input-top">[m
[31m-                            <input type="email" id="email" placeholder="" formControlName="email">[m
[31m-                            <p class="error_message" *ngIf="customerForm.get('email').invalid">Veuillez fournir un email valide.</p>[m
[32m+[m[32m                            <input type="email" id="email" placeholder="" formControlName="email" >[m
[32m+[m[32m                            <label for="email">Email* :</label>[m
[32m+[m[32m                            <span></span>[m
[32m+[m[32m                        </div>[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m[32m                        <div class="styled-input agile-styled-input-top">[m
[32m+[m[32m                            <input type="email" id="newEmail" placeholder="" formControlName="newEmail">[m
[32m+[m[32m                            <p class="error_message" *ngIf="emailForm.get('newEmail').invalid">Veuillez fournir un email valide.</p>[m
                             <label for="email">Nouveau Email* :</label>[m
                             <span></span>[m
                         </div>[m
[32m+[m
                         <div class="styled-input">[m
[31m-                            <input type="email" name="Email" required="">[m
[32m+[m[32m                            <input type="email" name="Email" formControlName="confirmEmail">[m
[32m+[m[32m                            <p class="error_message" *ngIf="emailForm.hasError('nomatch')">les 2 emails ne sont pas identiques .</p>[m
[32m+[m
                             <label>Confirmer* :</label>[m
                             <span></span>[m
                         </div>[m
                         <div class="styled-input">[m
[31m-                            <input type="password" name="Subject" required="">[m
[32m+[m[32m                            <input type="password" name="password" formControlName="password" (input)="onchange()">[m
[32m+[m[32m                            <p>{{msg}}</p>[m
                             <label>Mot de passe * :</label>[m
                             <span></span>[m
                         </div>[m
[31m-                        <input type="submit" value="Modifier" [disabled]="customerForm.invalid">[m
[32m+[m[32m                        <input type="submit" value="Modifier" [disabled]="emailForm.invalid || msg !== ''">[m
                     </form>[m
                 </div>[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
                     <div class="col-md-6 contact-form">[m
                         <h4 class="white-w3ls">Mon mot de   <span>passe</span></h4>[m
[31m-                        <form action="#" method="post">[m
[32m+[m[32m                        <form  [formGroup]="pwdForm" (ngSubmit)="onSubmitPwdForm()">[m
[32m+[m
                             <div class="styled-input agile-styled-input-top">[m
[31m-                                <input type="password" name="Name" required="">[m
[32m+[m[32m                                <input type="password" name="pwd" (input)="onPwdchange()" formControlName="password">[m
                                 <label>Ancien mot de passe* :</label>[m
[31m-                                <span></span>[m
[32m+[m[32m                                <p>{{msgPwd}}</p>[m
                             </div>[m
[32m+[m
                             <div class="styled-input">[m
[31m-                                <input type="password" name="Email" required="">[m
[32m+[m[32m                                <input type="password" name="pwd" formControlName="newPassword">[m
                                 <label>Nouveau mot de passe* :</label>[m
                                 <span></span>[m
                             </div>[m
[32m+[m
                             <div class="styled-input">[m
[31m-                                <input type="password" name="Subject" required="">[m
[32m+[m[32m                                <input type="password" formControlName="confirmPwd">[m
                                 <label>Confirmer* :</label>[m
[31m-                                <span></span>[m
[32m+[m[32m                                <p class="error_message" *ngIf="pwdForm.hasError('nomatch')">les 2 mot de passe  ne sont pas identiques .</p>[m
[32m+[m
                             </div>[m
 [m
[31m-                            <input type="submit" value="Modifier" [disabled]="customerForm.invalid">[m
[32m+[m[32m                            <input type="submit" value="Modifier" [disabled]="pwdForm.invalid || msgPwd !== ''">[m
                         </form>[m
                         <br>[m
                         <br>[m
[1mdiff --git a/src/app/customer-profile/customer-profile.component.ts b/src/app/customer-profile/customer-profile.component.ts[m
[1mindex d8e8a6c..43af12d 100644[m
[1m--- a/src/app/customer-profile/customer-profile.component.ts[m
[1m+++ b/src/app/customer-profile/customer-profile.component.ts[m
[36m@@ -1,8 +1,15 @@[m
 import { Component, OnInit } from '@angular/core';[m
 import {Router} from '@angular/router';[m
[31m-import {FormBuilder, FormGroup, Validators} from '@angular/forms';[m
[32m+[m[32mimport {FormBuilder, FormControl, FormGroup, Validators} from '@angular/forms';[m
 import {CustomerService} from '../services/customer.service';[m
 import {CustomerProfile} from '../models/CustomerProfile.mpodel';[m
[32m+[m[32mimport {UpdateEmail} from '../models/UpdateEmail';[m
[32m+[m[32mimport {UpdatePassword} from '../models/UpdatePassword.model';[m
[32m+[m[32mimport {emailMatcher} from './email-matcher';[m
[32m+[m[32mimport {oldPassword} from './old-password';[m
[32m+[m[32mimport {equal} from 'assert';[m
[32m+[m[32mimport {passwordMatcher} from './password-matcher';[m
[32m+[m
 [m
 @Component({[m
   selector: 'app-customer-profile',[m
[36m@@ -11,20 +18,27 @@[m [mimport {CustomerProfile} from '../models/CustomerProfile.mpodel';[m
 })[m
 export class CustomerProfileComponent implements OnInit {[m
     customerForm: FormGroup;[m
[32m+[m[32m    emailForm: FormGroup;[m
[32m+[m[32m    pwdForm: FormGroup;[m
     id = localStorage.getItem('id');[m
[32m+[m[32m    msg: string;[m
[32m+[m[32m    msgPwd: string;[m
[32m+[m[32m    password = localStorage.getItem('pwd');[m
     constructor(private formBuilder: FormBuilder,[m
                 private customerService: CustomerService,[m
                 private router: Router) { }[m
     ngOnInit() {[m
         this.initForm();[m
[32m+[m[32m        this.initEmailForm();[m
[32m+[m[32m        this.initPwdForm();[m
     }[m
 [m
      initForm() {[m
          const name = localStorage.getItem('name');[m
          const familyName = localStorage.getItem('familyName');[m
[31m-         const email = localStorage.getItem('email');[m
          const birthDate = localStorage.getItem('birthDate');[m
          const phoneNumber = localStorage.getItem('phoneNumber');[m
[32m+[m[32m         const email = localStorage.getItem('email');[m
          const sex = localStorage.getItem('sex');[m
          this.customerForm = this.formBuilder.group({[m
              name: name,[m
[36m@@ -42,10 +56,56 @@[m [mexport class CustomerProfileComponent implements OnInit {[m
             formValue['familyName'],[m
             formValue['email'],[m
             formValue['birthDate'],[m
[31m-            formValue['phoneNumber'],[m
[31m-            formValue['sex']);[m
[32m+[m[32m            formValue['phoneNumber'][m
[32m+[m[32m           );[m
 [m
         this.customerService.editCustomer(+this.id, newCustomer) ;[m
       /* this.router.navigate(['']);*/[m
     }[m
[32m+[m[32m    initEmailForm() {[m
[32m+[m[32m        this.emailForm = this.formBuilder.group({[m
[32m+[m[32m            email: localStorage.getItem('email'),[m
[32m+[m[32m            password: ['', [Validators.required] ],[m
[32m+[m[32m            newEmail: ['', [Validators.required, Validators.email]],[m
[32m+[m[32m            confirmEmail:   ['', [Validators.required, Validators.email]][m
[32m+[m[32m        }, { validator: emailMatcher }[m
[32m+[m[32m        );[m
[32m+[m[32m    }[m
[32m+[m[32m    onSubmitEmailForm() {[m
[32m+[m[32m        const formValue = this.emailForm.value;[m
[32m+[m[32m        const newCustomer = new UpdateEmail([m
[32m+[m[32m            formValue['newEmail'],[m
[32m+[m[32m        );[m
[32m+[m[32m        this.customerService.updateEmail(+this.id, newCustomer) ;[m
[32m+[m[32m        }[m
[32m+[m[32m    initPwdForm() {[m
[32m+[m[32m        this.pwdForm = this.formBuilder.group({[m
[32m+[m[32m                password: ['', [Validators.required] ],[m
[32m+[m[32m                newPassword: ['', [Validators.required, Validators.minLength(8),[m
[32m+[m[32m                    Validators.pattern('^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$')]],[m
[32m+[m[32m                confirmPwd:   ['', [Validators.required]][m
[32m+[m[32m            }, { validator: passwordMatcher }[m
[32m+[m[32m        );[m
[32m+[m[32m    }[m
[32m+[m[32m    onSubmitPwdForm() {[m
[32m+[m[32m        const formValue = this.pwdForm.value;[m
[32m+[m[32m        const newCustomer = new UpdatePassword([m
[32m+[m[32m            formValue['newPassword'],[m
[32m+[m[32m        );[m
[32m+[m[32m        this.customerService.updatePwd(+this.id, newCustomer) ;[m
[32m+[m[32m    }[m
[32m+[m[32m    onchange() {[m
[32m+[m[32m        if (this.emailForm.value.password !== localStorage.getItem( 'pwd')) {[m
[32m+[m[32m           this.msg = 'mot de passe erroné' ;[m
[32m+[m[32m        } else {[m
[32m+[m[32m            this.msg = '';[m
[32m+[m[32m        }[m
[32m+[m[32m    }[m
[32m+[m[32m    onPwdchange() {[m
[32m+[m[32m        if (this.pwdForm.value.password !== localStorage.getItem( 'pwd')) {[m
[32m+[m[32m            this.msgPwd = 'mot de passe erroné' ;[m
[32m+[m[32m        } else {[m
[32m+[m[32m            this.msgPwd = '';[m
[32m+[m[32m        }[m
[32m+[m[32m    }[m
 }[m
[1mdiff --git a/src/app/customer-profile/email-matcher.ts b/src/app/customer-profile/email-matcher.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..9b729fd[m
[1m--- /dev/null[m
[1m+++ b/src/app/customer-profile/email-matcher.ts[m
[36m@@ -0,0 +1,13 @@[m
[32m+[m[32mimport {AbstractControl} from '@angular/forms';[m
[32m+[m
[32m+[m[32mexport const emailMatcher = (control: AbstractControl): {[key: string]: boolean} => {[m
[32m+[m[32m    const email = control.get('newEmail');[m
[32m+[m[32m    const confirm = control.get('confirmEmail');[m
[32m+[m[32m    console.log('email is' + email.value + ' ' + confirm.value);[m
[32m+[m[32m    if (email.value === confirm.value) {[m
[32m+[m[32m        return null;[m
[32m+[m[32m    } else {[m
[32m+[m[32m        console.log('erreur de form email');[m
[32m+[m[32m        return { nomatch: true };[m
[32m+[m[32m    }[m
[32m+[m[32m};[m
[1mdiff --git a/src/app/customer-profile/old-password.ts b/src/app/customer-profile/old-password.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..081b3ab[m
[1m--- /dev/null[m
[1m+++ b/src/app/customer-profile/old-password.ts[m
[36m@@ -0,0 +1,11 @@[m
[32m+[m[32mimport {AbstractControl} from '@angular/forms';[m
[32m+[m
[32m+[m[32mexport const oldPassword = (control: AbstractControl): {[key: string]: boolean} => {[m
[32m+[m[32m    const pwd = control.get('password');[m
[32m+[m[32m    if (pwd.value === localStorage.getItem('pwd')) {[m
[32m+[m[32m        return null;[m
[32m+[m[32m    } else {[m
[32m+[m[32m        console.log('erreur de form pwd');[m
[32m+[m[32m        return { invalidPwd: true };[m
[32m+[m[32m    }[m
[32m+[m[32m};[m
[1mdiff --git a/src/app/customer-profile/password-matcher.ts b/src/app/customer-profile/password-matcher.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..ccb7fc5[m
[1m--- /dev/null[m
[1m+++ b/src/app/customer-profile/password-matcher.ts[m
[36m@@ -0,0 +1,11 @@[m
[32m+[m[32mimport {AbstractControl} from '@angular/forms';[m
[32m+[m
[32m+[m[32mexport const passwordMatcher = (control: AbstractControl): {[key: string]: boolean} => {[m
[32m+[m[32m    const pwd = control.get('newPassword');[m
[32m+[m[32m    const confirm = control.get('confirmPwd');[m
[32m+[m[32m    if (pwd.value === confirm.value) {[m
[32m+[m[32m        return null;[m
[32m+[m[32m    } else {[m
[32m+[m[32m        return { nomatch: true };[m
[32m+[m[32m    }[m
[32m+[m[32m};[m
[1mdiff --git a/src/app/models/CustomerProfile.mpodel.ts b/src/app/models/CustomerProfile.mpodel.ts[m
[1mindex bab0e67..2fa354b 100644[m
[1m--- a/src/app/models/CustomerProfile.mpodel.ts[m
[1m+++ b/src/app/models/CustomerProfile.mpodel.ts[m
[36m@@ -5,6 +5,5 @@[m [mexport class CustomerProfile {[m
         public email: string,[m
         public birth_date: string,[m
         public phone_number: number,[m
[31m-        public sex: string[m
     ) {}[m
 }[m
[1mdiff --git a/src/app/models/UpdateEmail.ts b/src/app/models/UpdateEmail.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..7a7b3f2[m
[1m--- /dev/null[m
[1m+++ b/src/app/models/UpdateEmail.ts[m
[36m@@ -0,0 +1,5 @@[m
[32m+[m[32mexport class UpdateEmail {[m
[32m+[m[32m    constructor([m
[32m+[m[32m        public email: string,[m
[32m+[m[32m    ) {}[m
[32m+[m[32m}[m
[1mdiff --git a/src/app/models/UpdatePassword.model.ts b/src/app/models/UpdatePassword.model.ts[m
[1mnew file mode 100644[m
[1mindex 0000000..f6b92bf[m
[1m--- /dev/null[m
[1m+++ b/src/app/models/UpdatePassword.model.ts[m
[36m@@ -0,0 +1,5 @@[m
[32m+[m[32mexport class UpdatePassword {[m
[32m+[m[32m    constructor([m
[32m+[m[32m        public pwd: string,[m
[32m+[m[32m    ) {}[m
[32m+[m[32m}[m
[1mdiff --git a/src/app/services/customer.service.ts b/src/app/services/customer.service.ts[m
[1mindex f87d9dc..f6f1d45 100644[m
[1m--- a/src/app/services/customer.service.ts[m
[1m+++ b/src/app/services/customer.service.ts[m
[36m@@ -49,6 +49,7 @@[m [mexport class CustomerService {[m
             localStorage.setItem('sponsorCode', customer.sponsor_code);[m
             localStorage.setItem('birthDate', customer.birth_date);[m
             localStorage.setItem('phoneNumber', customer.phone_number);[m
[32m+[m[32m            localStorage.setItem('pwd', pwd);[m
             return true;[m
         } else {return false; }[m
     }[m
[36m@@ -83,4 +84,32 @@[m [mexport class CustomerService {[m
         this.editCustomerToServer(newCustomer);[m
         console.log(newCustomer);[m
     }[m
[31m-}[m
\ No newline at end of file[m
[32m+[m[32m    updateEmail (id: number, newCustomer) {[m
[32m+[m[32m        this.getCustomers();[m
[32m+[m[32m        newCustomer.id = id;[m
[32m+[m[32m        localStorage.setItem('id', newCustomer.id);[m
[32m+[m[32m        localStorage.setItem('email', newCustomer.email);[m
[32m+[m[32m        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/customers/edit/email';[m
[32m+[m[32m        const b = JSON.stringify(newCustomer);[m
[32m+[m[32m        this.httpClient.put(url, b, {[m
[32m+[m[32m            headers: {'Content-Type': 'application/json'}[m
[32m+[m[32m        })[m
[32m+[m[32m            .subscribe([m
[32m+[m[32m                () => {}, (error) => {console.log( b + 'erreur' + error); }[m
[32m+[m[32m            );[m
[32m+[m[32m    }[m
[32m+[m[32m    updatePwd (id: number, newCustomer) {[m
[32m+[m[32m        this.getCustomers();[m
[32m+[m[32m        newCustomer.id = id;[m
[32m+[m[32m        localStorage.setItem('id', newCustomer.id);[m
[32m+[m[32m        localStorage.setItem('pwd', newCustomer.pwd);[m
[32m+[m[32m        const url = 'http://localhost:8888/pfe_marketplace/web/app_dev.php/api/customers/edit/pwd';[m
[32m+[m[32m        const b = JSON.stringify(newCustomer);[m
[32m+[m[32m        this.httpClient.put(url, b, {[m
[32m+[m[32m            headers: {'Content-Type': 'application/json'}[m
[32m+[m[32m        })[m
[32m+[m[32m            .subscribe([m
[32m+[m[32m                () => {}, (error) => {console.log( b + 'erreur' + error); }[m
[32m+[m[32m            );[m
[32m+[m[32m    }[m
[32m+[m[32m}[m

[33mcommit 1723f4c77a7137e8ef767420f5d7cadeb68f0c7e[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Wed May 2 12:48:14 2018 +0100

    basket

[1mdiff --git a/src/app/basket-list/basket-list.component.html b/src/app/basket-list/basket-list.component.html[m
[1mindex d27d212..3b81d20 100644[m
[1m--- a/src/app/basket-list/basket-list.component.html[m
[1m+++ b/src/app/basket-list/basket-list.component.html[m
[36m@@ -1,4 +1,41 @@[m
[32m+[m[32m<div class="container">[m
 [m
[32m+[m
[32m+[m[32m    <div class="row bs-wizard" style="border-bottom:0;">[m
[32m+[m
[32m+[m[32m        <div class="col-xs-3 bs-wizard-step active">[m
[32m+[m[32m            <div class="text-center bs-wizard-stepnum">Mon panier</div>[m
[32m+[m[32m            <div class="progress"><div class="progress-bar"></div></div>[m
[32m+[m[32m            <a  class="bs-wizard-dot"></a>[m
[32m+[m
[32m+[m[32m        </div>[m
[32m+[m
[32m+[m[32m        <div class="col-xs-3 bs-wizard-step disabled"><!-- complete -->[m
[32m+[m[32m            <div class="text-center bs-wizard-stepnum">Livraison</div>[m
[32m+[m[32m            <div class="progress"><div class="progress-bar"></div></div>[m
[32m+[m[32m            <a href="#" class="bs-wizard-dot"></a>[m
[32m+[m[32m        </div>[m
[32m+[m
[32m+[m[32m        <div class="col-xs-3 bs-wizard-step disabled"><!-- complete -->[m
[32m+[m[32m            <div class="text-center bs-wizard-stepnum">Paiement</div>[m
[32m+[m[32m            <div class="progress"><div class="progress-bar"></div></div>[m
[32m+[m[32m            <a href="#" class="bs-wizard-dot"></a>[m
[32m+[m[32m        </div>[m
[32m+[m
[32m+[m[32m        <div class="col-xs-3 bs-wizard-step disabled"><!-- active -->[m
[32m+[m[32m            <div class="text-center bs-wizard-stepnum">Confirmation</div>[m
[32m+[m[32m            <div class="progress"><div class="progress-bar"></div></div>[m
[32m+[m[32m            <a href="#" class="bs-wizard-dot"></a>[m
[32m+[m[32m        </div>[m
[32m+[m[32m    </div>[m
[32m+[m
[32m+[m[32m</div>[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m[32m<!--basket-->[m
 <div class="container" id="main">[m
     <h2 class="pink">Mon Panier</h2>[m
     <hr>[m
[1mdiff --git a/src/app/basket-list/basket-list.component.scss b/src/app/basket-list/basket-list.component.scss[m
[1mindex 014a079..8a04ac3 100644[m
[1m--- a/src/app/basket-list/basket-list.component.scss[m
[1m+++ b/src/app/basket-list/basket-list.component.scss[m
[36m@@ -6,9 +6,6 @@[m
 }[m
 [m
 [m
[31m-[m
[31m-[m
[31m-[m
 .quantity {[m
   float: left;[m
   margin-right: 15px;[m
[36m@@ -73,4 +70,26 @@[m
 }[m
 .shopping-cart {[m
   margin-top: 20px;[m
[31m-}[m
\ No newline at end of file[m
[32m+[m[32m}[m
[32m+[m[32m/*breadcrump*/[m
[32m+[m[32m.bs-wizard {margin-top: 40px;}[m
[32m+[m
[32m+[m[32m/*Form Wizard*/[m
[32m+[m[32m.bs-wizard {border-bottom: solid 1px #e0e0e0; padding: 0 0 10px 0;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step {padding: 0; position: relative;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step + .bs-wizard-step {}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step .bs-wizard-stepnum {color: #595959; font-size: 16px; margin-bottom: 5px;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step .bs-wizard-info {color: #999; font-size: 14px;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step > .bs-wizard-dot {position: absolute; width: 30px; height: 30px; display: block; background: #fbe8aa; top: 45px; left: 50%; margin-top: -15px; margin-left: -15px; border-radius: 50%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step > .bs-wizard-dot:after {content: ' '; width: 14px; height: 14px; background: #fbbd19; border-radius: 50px; position: absolute; top: 8px; left: 8px; }[m
[32m+[m[32m.bs-wizard > .bs-wizard-step > .progress {position: relative; border-radius: 0px; height: 8px; box-shadow: none; margin: 20px 0;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step > .progress > .progress-bar {width:0px; box-shadow: none; background: #fbe8aa;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.complete > .progress > .progress-bar {width:100%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.active > .progress > .progress-bar {width:50%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step:first-child.active > .progress > .progress-bar {width:0%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step:last-child.active > .progress > .progress-bar {width: 100%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.disabled > .bs-wizard-dot {background-color: #f5f5f5;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.disabled > .bs-wizard-dot:after {opacity: 0;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step:first-child  > .progress {left: 50%; width: 50%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step:last-child  > .progress {width: 50%;}[m
[32m+[m[32m.bs-wizard > .bs-wizard-step.disabled a.bs-wizard-dot{ pointer-events: none; }[m
\ No newline at end of file[m
[1mdiff --git a/src/app/top-nav/top-nav.component.ts b/src/app/top-nav/top-nav.component.ts[m
[1mindex bf1b63d..6f8152f 100644[m
[1m--- a/src/app/top-nav/top-nav.component.ts[m
[1m+++ b/src/app/top-nav/top-nav.component.ts[m
[36m@@ -13,7 +13,7 @@[m [mimport {Observable} from 'rxjs/Observable';[m
   templateUrl: './top-nav.component.html',[m
   styleUrls: ['./top-nav.component.scss'][m
 })[m
[31m-export class TopNavComponent implements OnInit{[m
[32m+[m[32mexport class TopNavComponent implements OnInit {[m
     subscribtion: Subscription ;[m
     public itemCount;[m
     public subscription: Subscription;[m
[1mdiff --git a/src/app/traveling/traveling.component.html b/src/app/traveling/traveling.component.html[m
[1mdeleted file mode 100644[m
[1mindex 85f265e..0000000[m
[1m--- a/src/app/traveling/traveling.component.html[m
[1m+++ /dev/null[m
[36m@@ -1,3 +0,0 @@[m
[31m-<p>[m
[31m-  traveling works![m
[31m-</p>[m
[1mdiff --git a/src/app/traveling/traveling.component.scss b/src/app/traveling/traveling.component.scss[m
[1mdeleted file mode 100644[m
[1mindex e69de29..0000000[m
[1mdiff --git a/src/app/traveling/traveling.component.ts b/src/app/traveling/traveling.component.ts[m
[1mdeleted file mode 100644[m
[1mindex 8b554cd..0000000[m
[1m--- a/src/app/traveling/traveling.component.ts[m
[1m+++ /dev/null[m
[36m@@ -1,15 +0,0 @@[m
[31m-import { Component, OnInit } from '@angular/core';[m
[31m-[m
[31m-@Component({[m
[31m-  selector: 'app-traveling',[m
[31m-  templateUrl: './traveling.component.html',[m
[31m-  styleUrls: ['./traveling.component.scss'][m
[31m-})[m
[31m-export class TravelingComponent implements OnInit {[m
[31m-[m
[31m-  constructor() { }[m
[31m-[m
[31m-  ngOnInit() {[m
[31m-  }[m
[31m-[m
[31m-}[m

[33mcommit 09e0396654972371fb90056252340b160e1b208e[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Wed May 2 10:19:14 2018 +0100

    update the logout button

[1mdiff --git a/src/app/top-nav/top-nav.component.ts b/src/app/top-nav/top-nav.component.ts[m
[1mindex 31daac4..bf1b63d 100644[m
[1m--- a/src/app/top-nav/top-nav.component.ts[m
[1m+++ b/src/app/top-nav/top-nav.component.ts[m
[36m@@ -29,8 +29,8 @@[m [mexport class TopNavComponent implements OnInit{[m
     }[m
     onLogOut() {[m
         localStorage.clear();[m
[32m+[m[32m        this.router.navigate(['']);[m
         window.location.reload();[m
[31m-        this.router.navigate(['auth']);[m
     }[m
     ngOnInit(): void {[m
         const auth = Observable.of(localStorage.getItem('isAuth'));[m

[33mcommit 8f163545152f35d92e4ae3c3ba9f366fa84b6f72[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Wed May 2 09:36:16 2018 +0100

    configure the button increase and decrease to along in interval 1 to 10

[1mdiff --git a/src/app/basket-list/basket-list.component.html b/src/app/basket-list/basket-list.component.html[m
[1mindex 2dca24c..d27d212 100644[m
[1m--- a/src/app/basket-list/basket-list.component.html[m
[1m+++ b/src/app/basket-list/basket-list.component.html[m
[36m@@ -20,10 +20,10 @@[m
                     </div>[m
                     <div class="col-4 col-sm-4 col-md-4">[m
                         <div class="quantity">[m
[31m-                            <input type="button" value="+" class="plus" (click)="onAdd(product.id,product.price)">[m
[32m+[m[32m                            <input type="button" value="+" class="plus" (click)="onAdd(product.id,product.price)" [disabled]="product.quantity>10">[m
                             <input type="text" step="1" max="10" min="1" [value]="product.quantity" title="Qty" class="qty"[m
                                    size="4"  disabled>[m
[31m-                            <input type="button" value="-" class="minus" (click)="onDecrease(product.id,product.price)">[m
[32m+[m[32m                            <input type="button" value="-" class="minus" (click)="onDecrease(product.id,product.price)" [disabled]="product.quantity<2">[m
                         </div>[m
                     </div>[m
                     <div class="col-2 col-sm-2 col-md-2 text-right">[m

[33mcommit 61a199d9c38622c403a39cf734d4cd848c32ee4f[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Wed May 2 09:30:23 2018 +0100

    add the decrease button

[1mdiff --git a/src/app/basket-list/basket-list.component.html b/src/app/basket-list/basket-list.component.html[m
[1mindex 25df297..2dca24c 100644[m
[1m--- a/src/app/basket-list/basket-list.component.html[m
[1m+++ b/src/app/basket-list/basket-list.component.html[m
[36m@@ -23,7 +23,7 @@[m
                             <input type="button" value="+" class="plus" (click)="onAdd(product.id,product.price)">[m
                             <input type="text" step="1" max="10" min="1" [value]="product.quantity" title="Qty" class="qty"[m
                                    size="4"  disabled>[m
[31m-                            <input type="button" value="-" class="minus">[m
[32m+[m[32m                            <input type="button" value="-" class="minus" (click)="onDecrease(product.id,product.price)">[m
                         </div>[m
                     </div>[m
                     <div class="col-2 col-sm-2 col-md-2 text-right">[m
[1mdiff --git a/src/app/basket-list/basket-list.component.ts b/src/app/basket-list/basket-list.component.ts[m
[1mindex b1b35d1..89661bf 100644[m
[1m--- a/src/app/basket-list/basket-list.component.ts[m
[1m+++ b/src/app/basket-list/basket-list.component.ts[m
[36m@@ -34,5 +34,8 @@[m [mexport class BasketListComponent  {[m
      this._basketService.increaseQuantity(id, price);[m
         this.total = this._basketService.totalPrice;[m
     }[m
[31m-[m
[32m+[m[32m    public onDecrease(id, price) {[m
[32m+[m[32m        this._basketService.decreaseQuantity(id, price);[m
[32m+[m[32m        this.total = this._basketService.totalPrice;[m
[32m+[m[32m    }[m
 }[m
[1mdiff --git a/src/app/services/shoping.service.ts b/src/app/services/shoping.service.ts[m
[1mindex a7fa231..1d2fd21 100644[m
[1m--- a/src/app/services/shoping.service.ts[m
[1m+++ b/src/app/services/shoping.service.ts[m
[36m@@ -55,11 +55,22 @@[m [mexport class ShopingService {[m
         const productIndexToRemove = this.products.findIndex([m
             (product) => {[m
                 if (product.id === id) {[m
[31m-                   product.quantity ++;[m
[31m-                   return true;[m
[32m+[m[32m                    product.quantity ++;[m
[32m+[m[32m                    return true;[m
                 }[m
             }[m
         );[m
         this.totalPrice += price;[m
     }[m
[32m+[m[32m    public decreaseQuantity(id, price) {[m
[32m+[m[32m        const productIndexToRemove = this.products.findIndex([m
[32m+[m[32m            (product) => {[m
[32m+[m[32m                if (product.id === id) {[m
[32m+[m[32m                    product.quantity --;[m
[32m+[m[32m                    return true;[m
[32m+[m[32m                }[m
[32m+[m[32m            }[m
[32m+[m[32m        );[m
[32m+[m[32m        this.totalPrice -= price;[m
[32m+[m[32m    }[m
 }[m

[33mcommit 87d2d3c931b640a11d61ea82bc675bc64cde4ac7[m
Merge: b51223e ec15a35
Author: pophamdi <pophamdi@gmail.com>
Date:   Wed May 2 09:22:06 2018 +0100

    Merge branch 'master' of https://github.com/HanoSoft/marketplace-angular

[33mcommit b51223e023278dc85763066e6f7c86be533f786a[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Wed May 2 09:21:29 2018 +0100

    enable the quantity ondelete and on add

[1mdiff --git a/src/app/basket-list/basket-list.component.html b/src/app/basket-list/basket-list.component.html[m
[1mindex 85b92da..25df297 100644[m
[1m--- a/src/app/basket-list/basket-list.component.html[m
[1m+++ b/src/app/basket-list/basket-list.component.html[m
[36m@@ -20,10 +20,10 @@[m
                     </div>[m
                     <div class="col-4 col-sm-4 col-md-4">[m
                         <div class="quantity">[m
[31m-                            <input type="button" value="+" class="plus" (click)="onAdd(product.price)">[m
[31m-                            <input type="text" step="1" max="10" min="1" [value]="quantity" title="Qty" class="qty"[m
[32m+[m[32m                            <input type="button" value="+" class="plus" (click)="onAdd(product.id,product.price)">[m
[32m+[m[32m                            <input type="text" step="1" max="10" min="1" [value]="product.quantity" title="Qty" class="qty"[m
                                    size="4"  disabled>[m
[31m-                            <input type="button" value="-" class="minus" (click)="onMinus()">[m
[32m+[m[32m                            <input type="button" value="-" class="minus">[m
                         </div>[m
                     </div>[m
                     <div class="col-2 col-sm-2 col-md-2 text-right">[m
[1mdiff --git a/src/app/basket-list/basket-list.component.ts b/src/app/basket-list/basket-list.component.ts[m
[1mindex 4c5b535..b1b35d1 100644[m
[1m--- a/src/app/basket-list/basket-list.component.ts[m
[1m+++ b/src/app/basket-list/basket-list.component.ts[m
[36m@@ -14,7 +14,6 @@[m [mexport class BasketListComponent  {[m
     private val: Subject <any>;[m
     products;[m
     total;[m
[31m-    quantity = 1;[m
     constructor(private _basketService: ShopingService) {[m
         this.val = _basketService.itemCountSource;[m
         this.itemCount = 0;[m
[36m@@ -31,12 +30,9 @@[m [mexport class BasketListComponent  {[m
         this.products = this._basketService.getProducts();[m
         this.total = this._basketService.totalPrice;[m
     }[m
[31m-    public onAdd(price) {[m
[31m-        this.quantity++;[m
[31m-        this.total = this.total + price;[m
[31m-    }[m
[31m-    public onMinus(price) {[m
[31m-        this.quantity--;[m
[31m-        this.total = this.total - price;[m
[32m+[m[32m    public onAdd(id, price) {[m
[32m+[m[32m     this._basketService.increaseQuantity(id, price);[m
[32m+[m[32m        this.total = this._basketService.totalPrice;[m
     }[m
[32m+[m
 }[m
[1mdiff --git a/src/app/services/shoping.service.ts b/src/app/services/shoping.service.ts[m
[1mindex 29c1b04..a7fa231 100644[m
[1m--- a/src/app/services/shoping.service.ts[m
[1m+++ b/src/app/services/shoping.service.ts[m
[36m@@ -41,6 +41,7 @@[m [mexport class ShopingService {[m
         const productIndexToRemove = this.products.findIndex([m
             (product) => {[m
                 if (product.id === id) {[m
[32m+[m[32m                    this.totalPrice -= product.quantity * price;[m
                     return true;[m
                 }[m
             }[m
[36m@@ -48,7 +49,17 @@[m [mexport class ShopingService {[m
         console.log (productIndexToRemove);[m
         this.itemCount--;[m
         this.itemCountSource.next(this.itemCount);[m
[31m-        this.totalPrice -= price;[m
         this.products.splice(productIndexToRemove, 1);[m
     }[m
[32m+[m[32m    public increaseQuantity(id, price) {[m
[32m+[m[32m        const productIndexToRemove = this.products.findIndex([m
[32m+[m[32m            (product) => {[m
[32m+[m[32m                if (product.id === id) {[m
[32m+[m[32m                   product.quantity ++;[m
[32m+[m[32m                   return true;[m
[32m+[m[32m                }[m
[32m+[m[32m            }[m
[32m+[m[32m        );[m
[32m+[m[32m        this.totalPrice += price;[m
[32m+[m[32m    }[m
 }[m

[33mcommit 32c7b826700aa4122b2b7d0cdd47d716842af359[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Wed May 2 09:09:12 2018 +0100

    create a triggered value for the quantity

[1mdiff --git a/src/app/basket-list/basket-list.component.html b/src/app/basket-list/basket-list.component.html[m
[1mindex 94f727b..85b92da 100644[m
[1m--- a/src/app/basket-list/basket-list.component.html[m
[1m+++ b/src/app/basket-list/basket-list.component.html[m
[36m@@ -20,10 +20,10 @@[m
                     </div>[m
                     <div class="col-4 col-sm-4 col-md-4">[m
                         <div class="quantity">[m
[31m-                            <input type="button" value="+" class="plus">[m
[31m-                            <input type="number" step="1" max="10" min="1" value="1" title="Qty" class="qty"[m
[31m-                                   size="4">[m
[31m-                            <input type="button" value="-" class="minus">[m
[32m+[m[32m                            <input type="button" value="+" class="plus" (click)="onAdd(product.price)">[m
[32m+[m[32m                            <input type="text" step="1" max="10" min="1" [value]="quantity" title="Qty" class="qty"[m
[32m+[m[32m                                   size="4"  disabled>[m
[32m+[m[32m                            <input type="button" value="-" class="minus" (click)="onMinus()">[m
                         </div>[m
                     </div>[m
                     <div class="col-2 col-sm-2 col-md-2 text-right">[m
[1mdiff --git a/src/app/basket-list/basket-list.component.ts b/src/app/basket-list/basket-list.component.ts[m
[1mindex 0f427d6..4c5b535 100644[m
[1m--- a/src/app/basket-list/basket-list.component.ts[m
[1m+++ b/src/app/basket-list/basket-list.component.ts[m
[36m@@ -14,6 +14,7 @@[m [mexport class BasketListComponent  {[m
     private val: Subject <any>;[m
     products;[m
     total;[m
[32m+[m[32m    quantity = 1;[m
     constructor(private _basketService: ShopingService) {[m
         this.val = _basketService.itemCountSource;[m
         this.itemCount = 0;[m
[36m@@ -30,5 +31,12 @@[m [mexport class BasketListComponent  {[m
         this.products = this._basketService.getProducts();[m
         this.total = this._basketService.totalPrice;[m
     }[m
[31m-[m
[32m+[m[32m    public onAdd(price) {[m
[32m+[m[32m        this.quantity++;[m
[32m+[m[32m        this.total = this.total + price;[m
[32m+[m[32m    }[m
[32m+[m[32m    public onMinus(price) {[m
[32m+[m[32m        this.quantity--;[m
[32m+[m[32m        this.total = this.total - price;[m
[32m+[m[32m    }[m
 }[m
[1mdiff --git a/src/app/product-details/product-details.component.html b/src/app/product-details/product-details.component.html[m
[1mindex 96bb776..b11a4d9 100644[m
[1m--- a/src/app/product-details/product-details.component.html[m
[1m+++ b/src/app/product-details/product-details.component.html[m
[36m@@ -64,7 +64,7 @@[m
                     </select>[m
                 </span>[m
                 <h5 style="margin-top: 10px;">Quantité :</h5>[m
[31m-                <select id="country1"  class="frm-field required sect">[m
[32m+[m[32m                <select id="quantity"  class="frm-field required sect">[m
                     <option value="null">1 </option>[m
                     <option value="null">2 </option>[m
                     <option value="null">3 </option>[m
[1mdiff --git a/src/app/product-details/product-details.component.ts b/src/app/product-details/product-details.component.ts[m
[1mindex ce49eb7..97122bc 100644[m
[1m--- a/src/app/product-details/product-details.component.ts[m
[1m+++ b/src/app/product-details/product-details.component.ts[m
[36m@@ -2,6 +2,7 @@[m [mimport {Component , OnInit} from '@angular/core';[m
 import {ActivatedRoute, Router} from '@angular/router';[m
 import {BrandService} from '../services/brand.service';[m
 import {ShopingService} from '../services/shoping.service';[m
[32m+[m[32mimport {FormGroup} from '@angular/forms';[m
 [m
 @Component({[m
   selector: 'app-product-details',[m
[36m@@ -17,6 +18,7 @@[m [mexport class ProductDetailsComponent implements OnInit {[m
     url = 'http://localhost:8888/pfe_marketplace/web/uploads/product/';[m
     basket ;[m
     selected = false;[m
[32m+[m[32m    quantity;[m
     constructor(private brandService: BrandService, private router: ActivatedRoute, private shoping: ShopingService) {[m
         this.basket = this.shoping.getProducts();[m
         this.id = this.router.snapshot.params['id'];[m
[36m@@ -31,8 +33,8 @@[m [mexport class ProductDetailsComponent implements OnInit {[m
     }[m
     ngOnInit(): void {[m
     }[m
[31m-    onAdd(id, price , name, image) {[m
[31m-        this.shoping.AddToBasket(id, price , name, image);[m
[32m+[m[32m    onAdd(id, price , name, image, quantity) {[m
[32m+[m[32m        this.shoping.AddToBasket(id, price , name, image, 1);[m
         this.selected = true;[m
         this.basket = this.shoping.getProducts();[m
     }[m
[1mdiff --git a/src/app/product/product.component.ts b/src/app/product/product.component.ts[m
[1mindex c8a81b1..ea16e10 100644[m
[1m--- a/src/app/product/product.component.ts[m
[1m+++ b/src/app/product/product.component.ts[m
[36m@@ -39,7 +39,7 @@[m [mexport class ProductComponent implements OnInit {[m
       }[m
   }[m
   onAdd(id, price , name, image) {[m
[31m-      this.shoping.AddToBasket(id, price , name, image);[m
[32m+[m[32m      this.shoping.AddToBasket(id, price , name, image, 1);[m
       this.selected = true;[m
       this.basket = this.shoping.getProducts();[m
   }[m
[1mdiff --git a/src/app/services/shoping.service.ts b/src/app/services/shoping.service.ts[m
[1mindex 86051a0..29c1b04 100644[m
[1m--- a/src/app/services/shoping.service.ts[m
[1m+++ b/src/app/services/shoping.service.ts[m
[36m@@ -14,21 +14,23 @@[m [mexport class ShopingService {[m
         this.totalPrice = 0.0;[m
     }[m
 [m
[31m-    public AddToBasket(id, price, name, image) {[m
[32m+[m[32m    public AddToBasket(id, price, name, image, quantity) {[m
         this.itemCount++;[m
         this.itemCountSource.next(this.itemCount);[m
[31m-        this.totalPrice += price;[m
[32m+[m[32m        this.totalPrice += price * quantity;[m
         // initialise the product[m
         const productObject = {[m
             id: '',[m
             product_name: '',[m
             price: '',[m
[31m-            image: ''[m
[32m+[m[32m            image: '',[m
[32m+[m[32m            quantity: ''[m
         };[m
         productObject.id = id;[m
         productObject.product_name = name;[m
         productObject.price = price;[m
         productObject.image = image;[m
[32m+[m[32m        productObject.quantity = quantity;[m
         this.products.push(productObject);[m
     }[m
     public getProducts () {[m

[33mcommit ec15a350266b5e4161f2f719aac449d9bea73548[m
Author: Nouha <nouha.bensalem1992@gmail.com>
Date:   Tue May 1 22:59:56 2018 +0100

    update profile.component.html

[1mdiff --git a/src/app/customer-profile/customer-profile.component.html b/src/app/customer-profile/customer-profile.component.html[m
[1mindex 89e6430..ceafae9 100644[m
[1m--- a/src/app/customer-profile/customer-profile.component.html[m
[1m+++ b/src/app/customer-profile/customer-profile.component.html[m
[36m@@ -1,24 +1,16 @@[m
[31m-[m
 <div class="banner_bottom_agile_info">[m
     <div class="container">[m
         <div class="agile-contact-grids">[m
             <div class="agile-contact-left">[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
                 <div class="col-md-6 address-grid">[m
[31m-[m
                     <div class="mail-agileits-w3layouts">[m
                         <h4>Informations <span>enregistrées</span></h4><br>[m
[31m-[m
                         <i class="fa fa-chevron-right" aria-hidden="true"></i>[m
                         <div class="contact-right">[m
                             <p>Vous avez déménagé ou vous souhaitez <br>changer votre mot de passe...</p>[m
                         </div>[m
                         <div class="clearfix"> </div>[m
                     </div>[m
[31m-[m
                     <div class="mail-agileits-w3layouts">[m
                         <i class="fa fa-chevron-right" aria-hidden="true"></i>[m
                         <div class="contact-right">[m
[36m@@ -26,7 +18,6 @@[m
                         </div>[m
                         <div class="clearfix"> </div>[m
                     </div>[m
[31m-[m
                     <div class="mail-agileits-w3layouts">[m
                         <i class="fa fa-chevron-right" aria-hidden="true"></i>[m
                         <div class="contact-right">[m
[36m@@ -34,19 +25,7 @@[m
                         </div>[m
                         <div class="clearfix"> </div>[m
                     </div>[m
[31m-[m
                 </div>[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
                 <div class="col-md-6 contact-form">[m
                     <h4 class="white-w3ls">Mes   <span>coordonnées</span></h4>[m
                     <form  [formGroup]="customerForm" (ngSubmit)="onSubmitForm()">[m
[36m@@ -67,43 +46,20 @@[m
                             <label  for="birthDate">Date de naissnace* :</label>[m
                             <span></span>[m
                         </div>[m
[31m-[m
                         <div class="styled-input">[m
                             <input type="number" id="tel" placeholder="Numéro de téléphone" formControlName="phoneNumber">[m
                             <label for="tel">Numéro de télephone* :</label>[m
                             <span></span>[m
                         </div>[m
[31m-[m
                         <div class="styled-input">[m
                             <select formControlName="sex" class="form-control form-control-sm">[m
                                 <option value="Homme" selected>Homme</option>[m
                                 <option value="Femme">Femme</option>[m
                             </select>[m
                         </div>[m
[31m-[m
                         <input type="submit" value="Modifier" [disabled]="customerForm.invalid">[m
                     </form>[m
[31m-[m
                 </div>[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
                 <div class="col-md-6 contact-form">[m
                     <h4 class="white-w3ls">Mon adresse  <span>Email</span></h4>[m
                     <form  [formGroup]="customerForm" (ngSubmit)="onSubmitForm()">[m
[36m@@ -123,30 +79,9 @@[m
                             <label>Mot de passe * :</label>[m
                             <span></span>[m
                         </div>[m
[31m-[m
                         <input type="submit" value="Modifier" [disabled]="customerForm.invalid">[m
                     </form>[m
                 </div>[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
                     <div class="col-md-6 contact-form">[m
                         <h4 class="white-w3ls">Mon mot de   <span>passe</span></h4>[m
                         <form action="#" method="post">[m
[36m@@ -174,29 +109,6 @@[m
                             * champs obligatoires[m
                         </div>[m
                     </div>[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
             </div>[m
         </div>[m
     </div>[m

[33mcommit 1ab8c66e4c94b5124fbe564c6148338429c59612[m
Merge: 6ebe322 dbbd31d
Author: Nouha <nouha.bensalem1992@gmail.com>
Date:   Tue May 1 22:55:03 2018 +0100

    Merge branch 'master' of https://github.com/HanoSoft/marketplace-angular

[33mcommit 6ebe322950b6ae1c576ffd5e07d0186c8894b4f5[m
Author: Nouha <nouha.bensalem1992@gmail.com>
Date:   Tue May 1 22:53:37 2018 +0100

    fix profil style

[1mdiff --git a/src/app/customer-profile/customer-profile.component.html b/src/app/customer-profile/customer-profile.component.html[m
[1mindex 0106100..89e6430 100644[m
[1m--- a/src/app/customer-profile/customer-profile.component.html[m
[1m+++ b/src/app/customer-profile/customer-profile.component.html[m
[36m@@ -1,124 +1,203 @@[m
[31m-<body class="align">[m
[32m+[m
[32m+[m[32m<div class="banner_bottom_agile_info">[m
     <div class="container">[m
[31m-        <div class="row">[m
[31m-                <div class="information">[m
[31m-                    <div class="login">[m
[31m-                        <h2>Voici vos informations enregistrées :</h2>[m
[32m+[m[32m        <div class="agile-contact-grids">[m
[32m+[m[32m            <div class="agile-contact-left">[m
[32m+[m
[32m+[m
 [m
[31m-                            <fieldset>[m
[31m-                                <p> Vous avez déménagé ou vous souhaitez changer votre mot de passe... <br>[m
[31m-                                    Faites les modifications dans les champs ci-dessous : votre compte sera immédiatement mis à jour.<br>[m
[31m-                                    Votre mot de passe doit comporter au minimum 8 caractères (dont 1 lettre et 1 chiffre)<br>[m
 [m
[31m-                                <p class="col-lg-offset-10" >*champs obligatoires</p>[m
[32m+[m[32m                <div class="col-md-6 address-grid">[m
 [m
[31m-                            </fieldset>[m
[32m+[m[32m                    <div class="mail-agileits-w3layouts">[m
[32m+[m[32m                        <h4>Informations <span>enregistrées</span></h4><br>[m
 [m
[32m+[m[32m                        <i class="fa fa-chevron-right" aria-hidden="true"></i>[m
[32m+[m[32m                        <div class="contact-right">[m
[32m+[m[32m                            <p>Vous avez déménagé ou vous souhaitez <br>changer votre mot de passe...</p>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <div class="clearfix"> </div>[m
                     </div>[m
[31m-                </div>[m
 [m
[31m-        <div class="row">[m
[31m-            <div class="col-lg-6 ">[m
[31m-                <div class="pers-details">[m
[31m-                    <div class="login">[m
[31m-                        <h2>Mes coordonnées</h2>[m
[31m-                        <form  [formGroup]="customerForm" (ngSubmit)="onSubmitForm()">[m
[31m-                            <fieldset>[m
[31m-                                <p><label for="name">Prénom* :</label></p>[m
[31m-                                <p><input type="text" id="name" placeholder="Prénom" formControlName="name"></p>[m
[31m-                                <p class="error_message" *ngIf="customerForm.get('name').invalid">Veuillez fournir au moins 3 caractères.</p>[m
[31m-[m
[31m-                                <p><label for="family-name">Nom* :</label></p>[m
[31m-                                <p><input type="text" id="family-name" placeholder="Nom" formControlName="familyName"></p>[m
[31m-                                <p class="error_message" *ngIf="customerForm.get('familyName').invalid">Veuillez fournir au moins 3 caractères.</p>[m
[31m-[m
[31m-                                <p><label for="birthDate">Date de naissance* :</label></p>[m
[31m-                                <p><input type="date" id="birthDate" placeholder="Date de naissance" formControlName="birthDate"></p>[m
[31m-[m
[31m-                                <p><label for="tel">Numéro de téléphone* :</label></p>[m
[31m-                                <p><input type="number" id="tel" placeholder="Numéro de téléphone" formControlName="phoneNumber"></p>[m
[31m-[m
[31m-                                <!--[m
[31m-                                <div class="col-md-6 mb-3">[m
[31m-                                    <p><label for="validationCustom03">Ville*:</label></p>[m
[31m-                                    <input type="text" class="form-control" id="validationCustom03" placeholder="Ville" required>[m
[31m-[m
[31m-                                </div>[m
[31m-                                <div class="col-md-3 mb-3">[m
[31m-                                    <p><label for="validationCustom04">Pays</label></p>[m
[31m-                                    <input type="text" class="form-control" id="validationCustom04" placeholder="Pays" required>[m
[31m-[m
[31m-                                </div>[m
[31m-                                <div class="col-md-3 mb-3">[m
[31m-                                    <p><label for="validationCustom05">Code postal</label></p>[m
[31m-                                    <input type="text" class="form-control" id="validationCustom05" placeholder="Code postal" required>[m
[31m-                                    <br>[m
[31m-                                </div>   -->[m
[31m-[m
[31m-                                <p><label >sexe* :</label></p>[m
[31m-                                <select formControlName="sex" class="form-control form-control-sm">[m
[31m-                                    <option value="Homme" selected>Homme</option>[m
[31m-                                    <option value="Femme">Femme</option>[m
[31m-                                </select>[m
[31m-                                <br>[m
[31m-                                <p><input type="submit" value="Modifier" [disabled]="customerForm.invalid"></p>[m
[31m-                            </fieldset>[m
[31m-                        </form>[m
[32m+[m[32m                    <div class="mail-agileits-w3layouts">[m
[32m+[m[32m                        <i class="fa fa-chevron-right" aria-hidden="true"></i>[m
[32m+[m[32m                        <div class="contact-right">[m
[32m+[m[32m                            <p>Faites les modifications dans <br>les champs ci-dessous votre <br> compte sera immédiatement mis à jour.</p>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <div class="clearfix"> </div>[m
[32m+[m[32m                    </div>[m
[32m+[m
[32m+[m[32m                    <div class="mail-agileits-w3layouts">[m
[32m+[m[32m                        <i class="fa fa-chevron-right" aria-hidden="true"></i>[m
[32m+[m[32m                        <div class="contact-right">[m
[32m+[m[32m                            <p>Votre mot de passe doit comporter <br>au minimum 8 caractères (dont 1 <br> lettre et 1 chiffre)</p>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <div class="clearfix"> </div>[m
                     </div>[m
[32m+[m
                 </div>[m
[31m-            </div>[m
 [m
[31m-    <div class="row">[m
[31m-        <div class="col-lg-offset-6">[m
[31m-            <div class="grid">[m
[31m-                <div class="login">[m
[31m-                    <h2>Mon adresse Email</h2>[m
[31m-                    <form  [formGroup]="customerForm" (ngSubmit)="onSubmitForm()">[m
[31m-                <fieldset>[m
[31m-                    <p><label for="email">Nouveau Email* :</label></p>[m
[31m-                    <p><input type="email" id="email" placeholder="" formControlName="email"></p>[m
[31m-                    <p class="error_message" *ngIf="customerForm.get('email').invalid">Veuillez fournir un email valide.</p>[m
 [m
[31m-                    <p><label for="email1">Confirmer* :</label></p>[m
[31m-                    <p><input type="email" id="email1" placeholder="" formControlName="email1"></p>[m
 [m
[31m-                    <p><label for="pwd1">Mot de passe * :</label></p>[m
[31m-                    <p><input type="password" id="pwd1" placeholder="" formControlName="pwd1"></p>[m
 [m
[31m-                    <p><input type="submit" value="Modifier" [disabled]="customerForm.invalid"></p>[m
 [m
[31m-                </fieldset>[m
[31m-            </form>[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m[32m                <div class="col-md-6 contact-form">[m
[32m+[m[32m                    <h4 class="white-w3ls">Mes   <span>coordonnées</span></h4>[m
[32m+[m[32m                    <form  [formGroup]="customerForm" (ngSubmit)="onSubmitForm()">[m
[32m+[m[32m                        <div class="styled-input agile-styled-input-top">[m
[32m+[m[32m                            <input type="text" id="name" placeholder="Prénom" formControlName="name">[m
[32m+[m[32m                            <p class="error_message" *ngIf="customerForm.get('name').invalid">Veuillez fournir au moins 3 caractères.</p>[m
[32m+[m[32m                            <label  for="name">Prénom* :</label>[m
[32m+[m[32m                            <span></span>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <div class="styled-input">[m
[32m+[m[32m                            <input type="text" id="family-name" placeholder="Nom" formControlName="familyName">[m
[32m+[m[32m                            <p class="error_message" *ngIf="customerForm.get('familyName').invalid">Veuillez fournir au moins 3 caractères.</p>[m
[32m+[m[32m                            <label for="family-name">Nom* :</label>[m
[32m+[m[32m                            <span></span>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <div class="styled-input">[m
[32m+[m[32m                            <input type="date" id="birthDate" placeholder="Date de naissance" formControlName="birthDate">[m
[32m+[m[32m                            <label  for="birthDate">Date de naissnace* :</label>[m
[32m+[m[32m                            <span></span>[m
[32m+[m[32m                        </div>[m
[32m+[m
[32m+[m[32m                        <div class="styled-input">[m
[32m+[m[32m                            <input type="number" id="tel" placeholder="Numéro de téléphone" formControlName="phoneNumber">[m
[32m+[m[32m                            <label for="tel">Numéro de télephone* :</label>[m
[32m+[m[32m                            <span></span>[m
[32m+[m[32m                        </div>[m
[32m+[m
[32m+[m[32m                        <div class="styled-input">[m
[32m+[m[32m                            <select formControlName="sex" class="form-control form-control-sm">[m
[32m+[m[32m                                <option value="Homme" selected>Homme</option>[m
[32m+[m[32m                                <option value="Femme">Femme</option>[m
[32m+[m[32m                            </select>[m
[32m+[m[32m                        </div>[m
[32m+[m
[32m+[m[32m                        <input type="submit" value="Modifier" [disabled]="customerForm.invalid">[m
[32m+[m[32m                    </form>[m
[32m+[m
                 </div>[m
[31m-            </div>[m
[31m-    </div>[m
[31m-        <div class="col-lg-offset-6" >[m
[31m-            <div class="grid">[m
[31m-                <div class="login">[m
[31m-                    <h2>Mon mot de passe</h2>[m
[31m-                    <form action="#" method="POST" >[m
[31m-                        <fieldset id="pwd">[m
[31m-                            <p><label for="password">Ancien mot de passe* :</label></p>[m
[31m-                            <p><input type="password" id="password" placeholder=""></p>[m
 [m
[31m-                            <p><label for="password">Nouveau mode passe* :</label></p>[m
[31m-                            <p><input type="password" id="new-password" placeholder=""></p>[m
 [m
[31m-                            <p><label for="password">Confirmer* :</label></p>[m
[31m-                            <p><input type="password" id="confirm-password" placeholder=""></p>[m
 [m
[31m-                            <p><input type="submit" value="Modifier"></p>[m
 [m
[31m-                        </fieldset>[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m[32m                <div class="col-md-6 contact-form">[m
[32m+[m[32m                    <h4 class="white-w3ls">Mon adresse  <span>Email</span></h4>[m
[32m+[m[32m                    <form  [formGroup]="customerForm" (ngSubmit)="onSubmitForm()">[m
[32m+[m[32m                        <div class="styled-input agile-styled-input-top">[m
[32m+[m[32m                            <input type="email" id="email" placeholder="" formControlName="email">[m
[32m+[m[32m                            <p class="error_message" *ngIf="customerForm.get('email').invalid">Veuillez fournir un email valide.</p>[m
[32m+[m[32m                            <label for="email">Nouveau Email* :</label>[m
[32m+[m[32m                            <span></span>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <div class="styled-input">[m
[32m+[m[32m                            <input type="email" name="Email" required="">[m
[32m+[m[32m                            <label>Confirmer* :</label>[m
[32m+[m[32m                            <span></span>[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                        <div class="styled-input">[m
[32m+[m[32m                            <input type="password" name="Subject" required="">[m
[32m+[m[32m                            <label>Mot de passe * :</label>[m
[32m+[m[32m                            <span></span>[m
[32m+[m[32m                        </div>[m
[32m+[m
[32m+[m[32m                        <input type="submit" value="Modifier" [disabled]="customerForm.invalid">[m
                     </form>[m
                 </div>[m
[31m-            </div>[m
[31m-        </div>[m
 [m
[31m-    </div>[m
[31m-    </div>[m
[31m-    </div>[m
[31m-    </div>[m
[31m-</body>[m
 [m
 [m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m[32m                    <div class="col-md-6 contact-form">[m
[32m+[m[32m                        <h4 class="white-w3ls">Mon mot de   <span>passe</span></h4>[m
[32m+[m[32m                        <form action="#" method="post">[m
[32m+[m[32m                            <div class="styled-input agile-styled-input-top">[m
[32m+[m[32m                                <input type="password" name="Name" required="">[m
[32m+[m[32m                                <label>Ancien mot de passe* :</label>[m
[32m+[m[32m                                <span></span>[m
[32m+[m[32m                            </div>[m
[32m+[m[32m                            <div class="styled-input">[m
[32m+[m[32m                                <input type="password" name="Email" required="">[m
[32m+[m[32m                                <label>Nouveau mot de passe* :</label>[m
[32m+[m[32m                                <span></span>[m
[32m+[m[32m                            </div>[m
[32m+[m[32m                            <div class="styled-input">[m
[32m+[m[32m                                <input type="password" name="Subject" required="">[m
[32m+[m[32m                                <label>Confirmer* :</label>[m
[32m+[m[32m                                <span></span>[m
[32m+[m[32m                            </div>[m
[32m+[m
[32m+[m[32m                            <input type="submit" value="Modifier" [disabled]="customerForm.invalid">[m
[32m+[m[32m                        </form>[m
[32m+[m[32m                        <br>[m
[32m+[m[32m                        <br>[m
[32m+[m[32m                        <div  style="float: right;">[m
[32m+[m[32m                            * champs obligatoires[m
[32m+[m[32m                        </div>[m
[32m+[m[32m                    </div>[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m[32m            </div>[m
[32m+[m[32m        </div>[m
[32m+[m[32m    </div>[m
[32m+[m[32m</div>[m
\ No newline at end of file[m
[1mdiff --git a/src/app/customer-profile/customer-profile.component.scss b/src/app/customer-profile/customer-profile.component.scss[m
[1mindex 904fe84..e69de29 100644[m
[1m--- a/src/app/customer-profile/customer-profile.component.scss[m
[1m+++ b/src/app/customer-profile/customer-profile.component.scss[m
[36m@@ -1,118 +0,0 @@[m
[31m-[m
[31m-/* profil */[m
[31m-[m
[31m-input {[m
[31m-  background-image: none;[m
[31m-  border: none;[m
[31m-  font: inherit;[m
[31m-  margin-top: 1px;[m
[31m-  margin-bottom: 1px;[m
[31m-  padding: 0;[m
[31m-  transition: all .3s;[m
[31m-[m
[31m-}[m
[31m-[m
[31m-.align{[m
[31m-  background-color: #DCDCDC;[m
[31m-}[m
[31m-[m
[31m-[m
[31m-[m
[31m-/* ---------- GRID ---------- */[m
[31m-.information{[m
[31m-  margin-top: 30px;[m
[31m-  margin-bottom: 1px;[m
[31m-  width: 1130px;[m
[31m-[m
[31m-}[m
[31m-.pers-details{[m
[31m-  margin-top: 50px;[m
[31m-  margin-bottom: 50px;[m
[31m-  width: 700px;[m
[31m-}[m
[31m-.grid {[m
[31m-  margin-top: 50px;[m
[31m-  margin-bottom: 50px;[m
[31m-  margin-left: 150px;[m
[31m-  max-width: 90%;[m
[31m-  width: 400px;[m
[31m-}[m
[31m-[m
[31m-/* ---------- LOGIN ---------- */[m
[31m-.parag{[m
[31m-  width: 100%;[m
[31m-  font-size: 18px;[m
[31m-}[m
[31m-[m
[31m-.login h2 {[m
[31m-  background: #f95252;[m
[31m-  border-radius: 20px 20px 0 0;[m
[31m-  color: #fff;[m
[31m-  font-size: 18px;[m
[31m-  padding: 15px 20px;[m
[31m-  margin-right:  50px;[m
[31m-[m
[31m-[m
[31m-}[m
[31m-[m
[31m-.login h2 span[class*="fontawesome-"] {[m
[31m-  margin-right: 14px;[m
[31m-}[m
[31m-[m
[31m-#pwd{[m
[31m-  background: #fff;[m
[31m-  border-radius: 0 0 20px 20px;[m
[31m-  padding: 15px 20px;[m
[31m-  height: 280px;[m
[31m-  margin-right:  50px;[m
[31m-[m
[31m-}[m
[31m-[m
[31m-.login fieldset {[m
[31m-  background: #fff;[m
[31m-  border-radius: 0 0 20px 20px;[m
[31m-  padding: 20px 26px;[m
[31m-  margin-right:  50px;[m
[31m-[m
[31m-}[m
[31m-[m
[31m-.login fieldset p {[m
[31m-  color: #696969;[m
[31m-  margin-bottom: 14px;[m
[31m-  font-size: 10px;[m
[31m-}[m
[31m-[m
[31m-.login fieldset p:last-child {[m
[31m-  margin-bottom: 0;[m
[31m-}[m
[31m-[m
[31m-.login fieldset input {[m
[31m-  border-radius: 3px;[m
[31m-[m
[31m-}[m
[31m-[m
[31m-[m
[31m-.login fieldset input[type="email"], .login fieldset input[type="password"], .login fieldset input[type="text"], .login fieldset input[type="date"],.login fieldset input[type="number"] {[m
[31m-  background: #F5F5F5;[m
[31m-  color: #777;[m
[31m-  padding: 4px 10px;[m
[31m-  width: 100%;[m
[31m-  border: #0e0e0e;[m
[31m-  font-size: 15px;[m
[31m-  margin: 1px;[m
[31m-}[m
[31m-[m
[31m-.login fieldset input[type="submit"] {[m
[31m-  background: #33cc77;[m
[31m-  color: #fff;[m
[31m-  display: block;[m
[31m-  margin: 0 auto;[m
[31m-  padding: 5px 0;[m
[31m-  width: 100px;[m
[31m-  font-size: 12px;[m
[31m-[m
[31m-}[m
[31m-[m
[31m-.login fieldset input[type="submit"]:hover {[m
[31m-  background: #28ad63;[m
[31m-}[m
\ No newline at end of file[m
[1mdiff --git a/src/assets/css/style.css b/src/assets/css/style.css[m
[1mindex d0926e5..ac8084c 100644[m
[1m--- a/src/assets/css/style.css[m
[1m+++ b/src/assets/css/style.css[m
[36m@@ -772,9 +772,7 @@[m [mfigure.effect-roxy:hover p,.agileinfo_banner_bottom_grid_three_left:hover figcap[m
     width: 49.5%;[m
     float: left;[m
 }[m
[31m-.banner_bottom_agile_info {[m
[31m-    padding: 5em 0;[m
[31m-}[m
[32m+[m
 .banner_bottom_agile_info.team {[m
     background: #f5f5f5;[m
 }[m
[36m@@ -955,13 +953,14 @@[m [mcolor: #2fdab8;[m
     margin-top: 0;[m
 }[m
 .address-grid {[m
[31m-    padding: 1em 0em 0 0em;[m
[32m+[m[32m    padding: 2em 0em 0 0em;[m
 }[m
 .contact-form {[m
[31m-    background: #181919;[m
[32m+[m[32m    background: #fff;[m
     padding: 5em 3em;[m
[32m+[m
 }[m
[31m-.contact input[type="text"], .contact input[type="email"], .contact textarea {[m
[32m+[m[32m.contact input[type="text"], .contact input[type="email"], .contact textarea,.contact input[type="password"] {[m
     font-size: 15px;[m
     letter-spacing: 1px;[m
     color: #fff;[m
[36m@@ -1034,7 +1033,7 @@[m [mcolor: #2fdab8;[m
 	transition: all 0.075s;[m
 }[m
 .white-w3ls{[m
[31m-	color:#fff!important;[m
[32m+[m	[32mcolor: black !important;[m
 }[m
 .modal-body-sub {[m
     padding:2em !important;[m
[36m@@ -2044,10 +2043,10 @@[m [mh3.tittle {[m
     padding-left: 2em;[m
     float: left;[m
 }[m
[31m-.contact-form input[type="text"], .contact-form input[type="email"], .contact-form textarea {[m
[32m+[m[32m.contact-form input[type="text"], .contact-form input[type="email"], .contact-form textarea,.contact-form input[type="password"],.contact-form input[type="date"],.contact-form input[type="number"] {[m
     font-size: 15px;[m
     letter-spacing: 1px;[m
[31m-    color: #fff;[m
[32m+[m[32m    color: #000000;[m
     padding: 0.5em 1em;[m
     border: 0;[m
     width: 100%;[m
[36m@@ -2071,7 +2070,7 @@[m [mh3.tittle {[m
     text-transform: uppercase;[m
     font-weight: 700;[m
     color: #2fdab8;[m
[31m-    font-size: 1em;[m
[32m+[m[32m    font-size: 14px;[m
     letter-spacing: 2px;[m
 	margin-bottom: 0.5em;[m
 }[m
[36m@@ -2087,6 +2086,7 @@[m [mh3.tittle {[m
     text-transform: uppercase;[m
     color: #181919;[m
 	letter-spacing:1px;[m
[32m+[m
 }[m
 .address-grid h4 span,h4.white-w3ls span{[m
   font-weight:300;[m
[36m@@ -3738,7 +3738,7 @@[m [mp.w3ls_para {[m
 		font-size: 14px;[m
 	}[m
 	.banner_bottom_agile_info{[m
[31m-	   padding:4em 0;[m
[32m+[m	[32m   padding:2em 0;[m
 	}[m
 	.carousel-caption {[m
 		min-height: 450px!important;[m
[36m@@ -5546,3 +5546,145 @@[m [mp.w3ls_para {[m
     }[m
 }[m
 [m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m[32m.textfield {[m
[32m+[m[32m    float: inherit;[m
[32m+[m[32m    left: inherit;[m
[32m+[m[32m    margin-top: 10px;[m
[32m+[m[32m    padding-left: 10px;[m
[32m+[m[32m    padding-right: 10px;[m
[32m+[m[32m    width: 250px;[m
[32m+[m[32m    text-align: center;[m
[32m+[m[32m    border: #0e0e0e;[m
[32m+[m
[32m+[m[32m}[m
[32m+[m[32m#btn-parrainage:hover{[m
[32m+[m
[32m+[m[32m    -webkit-transition-duration: 0.4s;[m
[32m+[m[32m    transition-duration: 0.4s;[m
[32m+[m[32m    box-shadow: 0 12px 16px 0 rgba(0,0,0,0.24), 0 17px 50px 0 rgba(0,0,0,0.19);[m
[32m+[m
[32m+[m[32m}[m
[32m+[m[32m.center-block {[m
[32m+[m[32m    float:none;[m
[32m+[m[32m    background-color: #FF007F;[m
[32m+[m[32m    margin-top: 15px;[m
[32m+[m[32m    border: #FF007F;[m
[32m+[m[32m    color: #fff;[m
[32m+[m[32m    padding: 10px 24px;[m
[32m+[m[32m    font-size: 10px;[m
[32m+[m[32m    border-radius: 8px;[m
[32m+[m[32m    box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2), 0 6px 20px 0 rgba(0,0,0,0.19);[m
[32m+[m[32m}[m
[32m+[m[32m.espace{[m
[32m+[m[32m    padding-bottom: 20px;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m/* Dropdown Button : hover*/[m
[32m+[m
[32m+[m[32m/* The container <div> - needed to position the dropdown content */[m
[32m+[m[32m.dropdown {[m
[32m+[m[32m    position: relative;[m
[32m+[m[32m    display: inline-block;[m
[32m+[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m/* Dropdown Content (Hidden by Default) */[m
[32m+[m[32m.dropdown-content {[m
[32m+[m[32m    display: none;[m
[32m+[m[32m    position: absolute;[m
[32m+[m[32m    background-color: #f1f1f1;[m
[32m+[m[32m    min-width: 200px;[m
[32m+[m[32m    box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);[m
[32m+[m[32m    z-index: 1;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m/* Links inside the dropdown */[m
[32m+[m[32m.dropdown-content a {[m
[32m+[m[32m    color: black;[m
[32m+[m[32m    padding: 12px 16px;[m
[32m+[m[32m    display: block;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m/* Change color of dropdown links on hover */[m
[32m+[m[32m.dropdown-content a:hover {[m
[32m+[m[32m    color: #CD075C;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m/* Show the dropdown menu on hover */[m
[32m+[m[32m.dropdown:hover .dropdown-content {[m
[32m+[m[32m    display: block;[m
[32m+[m[32m    background-color: #fff;[m
[32m+[m
[32m+[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m/* Change the background color of the dropdown button when the dropdown content is shown */[m
[32m+[m[32m.dropdown:hover .dropbtn {[m
[32m+[m[32m    background-color: #3e8e41;[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m.icon-list[m
[32m+[m[32m{[m
[32m+[m[32m    margin-left: 200px;[m
[32m+[m[32m}[m
[32m+[m[32m.icon-list li[m
[32m+[m[32m{[m
[32m+[m[32m    display: inline-block;[m
[32m+[m[32m    text-align: center;[m
[32m+[m[32m}[m
[32m+[m[32m.icon-list li a[m
[32m+[m[32m{[m
[32m+[m[32m    font-size: 20px;[m
[32m+[m[32m    display: -webkit-box;[m
[32m+[m[32m    display: -moz-box;[m
[32m+[m[32m    display: -ms-flexbox;[m
[32m+[m[32m    display: -webkit-flex;[m
[32m+[m[32m    display: flex;[m
[32m+[m[32m    flex-direction: column;[m
[32m+[m[32m    justify-content: center;[m
[32m+[m[32m    align-items: center;[m
[32m+[m[32m    position: relative;[m
[32m+[m[32m    width: 40px;[m
[32m+[m[32m    height: 40px;[m
[32m+[m[32m    color: #1e1e27;[m
[32m+[m[32m    -webkit-transition: color 0.3s ease;[m
[32m+[m[32m    -moz-transition: color 0.3s ease;[m
[32m+[m[32m    -ms-transition: color 0.3s ease;[m
[32m+[m[32m    -o-transition: color 0.3s ease;[m
[32m+[m[32m    transition: color 0.3s ease;[m
[32m+[m[32m}[m
[32m+[m[32m.icon-list li a:hover[m
[32m+[m[32m{[m
[32m+[m[32m    color: #b5aec4;[m
[32m+[m[32m}[m
[32m+[m[32m.checkout a[m
[32m+[m[32m{[m
[32m+[m[32m    background: #eceff6;[m
[32m+[m[32m    border-radius: 50%;[m
[32m+[m[32m}[m
[32m+[m[32m.checkout_items[m
[32m+[m[32m{[m
[32m+[m[32m    display: -webkit-box;[m
[32m+[m[32m    display: -moz-box;[m
[32m+[m[32m    display: -ms-flexbox;[m
[32m+[m[32m    display: -webkit-flex;[m
[32m+[m[32m    display: flex;[m
[32m+[m[32m    flex-direction: column;[m
[32m+[m[32m    justify-content: center;[m
[32m+[m[32m    align-items: center;[m
[32m+[m[32m    position: absolute;[m
[32m+[m[32m    top: -9px;[m
[32m+[m[32m    left: 22px;[m
[32m+[m[32m    width: 20px;[m
[32m+[m[32m    height: 20px;[m
[32m+[m[32m    border-radius: 50%;[m
[32m+[m[32m    background: #FF007F;[m
[32m+[m[32m    font-size: 12px;[m
[32m+[m[32m    color: #FFFFFF;[m
[32m+[m[32m}[m
[32m+[m

[33mcommit dbbd31db88da60a99fe5bd1e554d6149164d5efa[m
Author: pophamdi <pophamdi@gmail.com>
Date:   Tue May 1 17:14:09 2018 +0100

    create a dynamic basket

[1mdiff --git a/src/app/app.module.ts b/src/app/app.module.ts[m
[1mindex 9dd7b0a..8f436ab 100644[m
[1m--- a/src/app/app.module.ts[m
[1m+++ b/src/app/app.module.ts[m
[36m@@ -41,7 +41,7 @@[m [mconst appRoutes: Routes = [[m
     { path: '', component: HomeComponent},[m
     /*basket-list*/[m
     { path: 'basket', component: BasketListComponent},[m
[31m-    { path: 'clothes', canActivate: [AuthGuard], component: ClothesComponent},[m
[32m+[m[32m    { path: 'clothes',  component: ClothesComponent},[m
     { path: 'beauty',  component: BeautyComponent},[m
     { path: 'HighTec',  component: HighTecComponent},[m
     { path: 'jewelry',  component: JewelryComponent},[m
[1mdiff --git a/src/app/product-details/product-details.component.html b/src/app/product-details/product-details.component.html[m
[1mindex c0e59ab..96bb776 100644[m
[1m--- a/src/app/product-details/product-details.component.html[m
[1m+++ b/src/app/product-details/product-details.component.html[m
[36m@@ -82,8 +82,9 @@[m
 [m
 [m
                 <input type="submit" name="submit" value="Ajouter au panier" class="button"[m
[31m-                       (click)="onAdd(product.id,product.price,product.product_name,url+product.images[0].name)">[m
[32m+[m[32m                       (click)="onAdd(product.id,product.price,product.product_name,url+product.images[0].name)" *ngIf="!selected" >[m
 [m
[32m+[m[32m                <input type="submit" name="submit" value="Supprimer" class="button" (click)="onDelete(product.id,product.price)" *ngIf="selected">[m
 [m
             </div>[m
 [m
[1mdiff --git a/src/app/product-details/product-details.component.ts b/src/app/product-details/product-details.component.ts[m
[1mindex 007c344..ce49eb7 100644[m
[1m--- a/src/app/product-details/product-details.component.ts[m
[1m+++ b/src/app/product-details/product-details.component.ts[m
[36m@@ -15,15 +15,30 @@[m [mexport class ProductDetailsComponent implements OnInit {[m
     idp;[m
     urlBrand = 'http://localhost:8888/pfe_marketplace/web/uploads/brand/';[m
     url = 'http://localhost:8888/pfe_marketplace/web/uploads/product/';[m
[32m+[m[32m    basket ;[m
[32m+[m[32m    selected = false;[m
     constructor(private brandService: BrandService, private router: ActivatedRoute, private shoping: ShopingService) {[m
[32m+[m[32m        this.basket = this.shoping.getProducts();[m
         this.id = this.router.snapshot.params['id'];[m
         this.idc = +this.router.snapshot.params['idc'];[m
          this.idp = this.router.snapshot.params['idp'];[m
         this.brand = this.brandService.getBrand(+this.id);[m
[32m+[m[32m        for (const b of this.basket) {[m
[32m+[m[32m            if (this.idp === b.id.toString()) {[m
[32m+[m[32m                this.selected = true;[m
[32m+[m[32m            }[m
[32m+[m[32m        }[m
     }[m
     ngOnInit(): void {[m
     }[m
     onAdd(id, price , name, image) {[m
         this.shoping.AddToBasket(id, price , name, image);[m
[32m+[m[32m        this.selected = true;[m
[32m+[m[32m        this.basket = this.shoping.getProducts();[m
[32m+[m[32m    }[m
[32m+[m[32m    public onDelete(id, price) {[m
[32m+[m[32m        this.shoping.remove(id, price);[m
[32m+[m[32m        this.selected = false;[m
[32m+[m[32m        this.basket = this.shoping.getProducts();[m
     }[m
 }[m
[1mdiff --git a/src/app/product/product.component.html b/src/app/product/product.component.html[m
[1mindex 095560b..62677ea 100644[m
[1m--- a/src/app/product/product.component.html[m
[1m+++ b/src/app/product/product.component.html[m
[36m@@ -18,20 +18,10 @@[m
                 <del>{{price}} €</del>[m
             </div>[m
             <div class="snipcart-details top_brand_home_details item_add single-item hvr-outline-out button2">[m
[31m-                <form action="#" method="post">[m
[31m-                    <fieldset>[m
[31m-                        <input type="hidden" name="cmd" value="_cart">[m
[31m-                        <input type="hidden" name="add" value="1">[m
[31m-                        <input type="hidden" name="business" value=" ">[m
[31m-                        <input type="hidden" name="item_name" value="Black Basic Shorts">[m
[31m-                        <input type="hidden" name="amount" value="30.99">[m
[31m-                        <input type="hidden" name="discount_amount" value="1.00">[m
[31m-                        <input type="hidden" name="currency_code" value="EUR">[m
[31m-                        <input type="hidden" name="return" value=" ">[m
[31m-                        <input type="hidden" name="cancel_return" value=" ">[m
[31m-                        <input type="submit" name="submit" value="Ajouter au panier" class="button" (click)="onAdd(id,price,productName,url+images[0].name)">[m
[31m-                    </fieldset>[m
[31m-                </form>[m
[32m+[m
[32m+[m[32m            <input type="submit" name="submit" value="Ajouter au panier" class="button" (click)="onAdd(id,price,productName,url+images[0].name)" *ngIf="!selected">[m
[32m+[m
[32m+[m[32m            <input type="submit" name="submit" value="Supprimer" class="button" (click)="onDelete(id,price)" *ngIf="selected">[m
 [m
             </div>[m
         </div>[m
[1mdiff --git a/src/app/product/product.component.ts b/src/app/product/product.component.ts[m
[1mindex 49ab84f..c8a81b1 100644[m
[1m--- a/src/app/product/product.component.ts[m
[1m+++ b/src/app/product/product.component.ts[m
[36m@@ -4,6 +4,9 @@[m [mimport {Router} from '@angular/router';[m
 import {Component, Input, OnInit} from '@angular/core';[m
 import {TopNavComponent} from '../top-nav/top-nav.component';[m
 import {Shoping} from '../models/Shoping';[m
[32m+[m[32mimport {Subscription} from 'rxjs/Subscription';[m
[32m+[m[32mimport {Subject} from 'rxjs/Subject';[m
[32m+[m[32mimport {forEach} from '@angular/router/src/utils/collection';[m
 [m
 @Component({[m
     providers: [TopNavComponent ],[m
[36m@@ -20,11 +23,29 @@[m [mexport class ProductComponent implements OnInit {[m
     @Input() price: number;[m
     @Input() quantity: number ;[m
     @Input() images = [];[m
[32m+[m[32m    public subscription: Subscription;[m
[32m+[m[32m    private val: Subject <any>;[m
[32m+[m[32m    basket ;[m
[32m+[m[32m    selected = false;[m
     url = 'http://localhost:8888/pfe_marketplace/web/uploads/product/';[m
[31m-  constructor(private shoping: ShopingService, private route: Router ) { }[m
[32m+[m[32m  constructor(private shoping: ShopingService, private route: Router ) {[m
[32m+[m[32m      this.basket = this.shoping.getProducts();[m
[32m+[m[32m  }[m
   ngOnInit() {[m
[32m+[m[32m      for (const b of this.basket) {[m
[32m+[m[32m      if (this.id === b.id) {[m
[32m+[m[32m          this.selected = true;[m
[32m+[m[32m      }[m
[32m+[m[32m      }[m
   }[m
   onAdd(id, price , name, image) {[m
       this.shoping.AddToBasket(id, price , name, image);[m
[32m+[m[32m      this.selected = true;[m
[32m+[m[32m      this.basket = this.shoping.getProducts();[m
   }[m
[32m+[m[32m    public onDelete(id, price) {[m
[32m+[m[32m        this.shoping.remove(id, price);[m
[32m+[m[32m        this.selected = false;[m
[32m+[m[32m        this.basket = this.shoping.getProducts();[m
[32m+[m[32m    }[m
 }[m
[1mdiff --git a/src/app/top-nav/top-nav.component.html b/src/app/top-nav/top-nav.component.html[m
[1mindex 830b30b..eac8747 100644[m
[1m--- a/src/app/top-nav/top-nav.component.html[m
[1m+++ b/src/app/top-nav/top-nav.component.html[m
[36m@@ -1,8 +1,8 @@[m
 <div class="header" id="home">[m
     <div class="container">[m
         <ul>[m
[31m-            <li> <a routerLink="auth"  ><i class="fa fa-unlock-alt" aria-hidden="true"></i> Se connecter </a></li>[m
[31m-            <li> <a routerLink="signup"  ><i class="fa fa-pencil-square-o" aria-hidden="true"></i> S'inscrire </a></li>[m
[32m+[m[32m            <li> <a routerLink="auth"  *ngIf="!isAuth"><i class="fa fa-unlock-alt" aria-hidden="true"></i> Se connecter </a></li>[m
[32m+[m[32m            <li> <a routerLink="signup" *ngIf="!isAuth" ><i class="fa fa-pencil-square-o" aria-hidden="true"></i> S'inscrire </a></li>[m
             <li><i class="fa fa-phone" aria-hidden="true"></i> Appel : +555 558 7885</li>[m
             <li><i class="fa fa-envelope-o" aria-hidden="true"></i> <a href="#">sbzMarket@contact.com</a></li>[m
         </ul>[m
[36m@@ -31,7 +31,8 @@[m
         <div class="col-md-4 agileits-social top_content">[m
             <ul class="icon-list">[m
                 <div class="dropdown">[m
[31m-                    <li ><a href="#"><i class="fa fa-users" aria-hidden="true"></i></a></li>[m
[32m+[m[32m                    <li *ngIf="isAuth" >[m
[32m+[m[32m                        <a href=""><i class="fa fa-users" aria-hidden="true"></i></a></li>[m
                         <div class=" dropdown-content">[m
                             <p class="gras textfield">Parrainez et gagnez  12 €</p>[m
                         <div class="textfield">[m
[36m@@ -48,7 +49,7 @@[m
                     </div>[m
                 </div>[m
                 <div class="dropdown">[m
[31m-                    <li><a href="#"><i class="fa fa-user" aria-hidden="true"></i></a> </li>[m
[32m+[m[32m                    <li *ngIf="isAuth"><a href="#"><i class="fa fa-user" aria-hidden="true"></i></a> </li>[m
                     <div class="dropdown-content ">[m
                         <a href="#"><i class="fa fa-list" aria-hidden="true"></i>  Mes Commandes</a>[m
                         <a href="#"><i class="fa fa-tag" aria-hidden="true"></i>  Mes Avantages</a>[m
[1mdiff --git a/src/app/top-nav/top-nav.component.ts b/src/app/top-nav/top-nav.component.ts[m
[1mindex 16ac653..31daac4 100644[m
[1m--- a/src/app/top-nav/top-nav.component.ts[m
[1m+++ b/src/app/top-nav/top-nav.component.ts[m
[36m@@ -5,6 +5,7 @@[m [mimport {Shoping} from '../models/Shoping';[m
 import {Subscription} from 'rxjs/Subscription';[m
 import {getTemplate} from 'codelyzer/util/ngQuery';[m
 import {Subject} from 'rxjs/Subject';[m
[32m+[m[32mimport {Observable} from 'rxjs/Observable';[m
 [m
 [m
 @Component({[m
[36m@@ -12,10 +13,12 @@[m [mimport {Subject} from 'rxjs/Subject';[m
   templateUrl: './top-nav.component.html',[m
   styleUrls: ['./top-nav.component.scss'][m
 })[m
[31m-export class TopNavComponent {[m
[32m+[m[32mexport class TopNavComponent implements OnInit{[m
[32m+[m[32m    subscribtion: Subscription ;[m
     public itemCount;[m
     public subscription: Subscription;[m
     private val: Subject <any>;[m
[32m+[m[32m    isAuth: string;[m
     constructor(private router: Router, private _basketService: ShopingService) {[m
         this.val = _basketService.itemCountSource;[m
         this.itemCount = 0;[m
[36m@@ -29,4 +32,11 @@[m [mexport class TopNavComponent {[m
         window.location.reload();[m
         this.router.navigate(['auth']);[m
     }[m
[32m+[m[32m    ngOnInit(): void {[m
[32m+[m[32m        const auth = Observable.of(localStorage.getItem('isAuth'));[m
[32m+[m[32m        this.subscribtion = auth.subscribe([m
[32m+[m[32m            (value) => {[m
[32m+[m[32m                this.isAuth = value;[m
[32m+[m[32m            });[m
[32m+[m[32m    }[m
 }[m
