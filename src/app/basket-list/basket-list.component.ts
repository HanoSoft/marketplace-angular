import {Component, OnInit, TemplateRef} from '@angular/core';
import {ShopingService} from '../services/shoping.service';
import {Subject} from 'rxjs/Subject';
import {Subscription} from 'rxjs/Subscription';
import {BsModalRef, BsModalService} from 'ngx-bootstrap';

@Component({
  selector: 'app-basket-list',
  templateUrl: './basket-list.component.html',
  styleUrls: ['./basket-list.component.scss']
})
export class BasketListComponent  {
    public itemCount;
    public subscription: Subscription;
    private val: Subject <any>;
    products;
    total;
    modalRef: BsModalRef;
    openModal(template: TemplateRef<any>) {
        this.modalRef = this.modalService.show(template);
    }
    closeModal() {
        this.modalRef.hide();
    }
    constructor(private _basketService: ShopingService, private modalService: BsModalService) {
        this._basketService.initialse();
        this.products = this._basketService.getProducts();
        this.val = _basketService.itemCountSource;
        this.itemCount = 0;
        this.subscription = _basketService.itemCount$.subscribe(
            data => {
                this.itemCount = data;
            });
        this.total = this._basketService.totalPrice;
    }

    public onDelete(id, price) {
        this._basketService.remove(id, price);
        this.products = this._basketService.getProducts();
        this.total = this._basketService.totalPrice;
        this.closeModal();
    }
    public onAdd(id, price) {
     this._basketService.increaseQuantity(id, price);
        this.total = this._basketService.totalPrice;
    }
    public onDecrease(id, price) {
        this._basketService.decreaseQuantity(id, price);
        this.total = this._basketService.totalPrice;
    }
}
