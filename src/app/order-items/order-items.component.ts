import {Component, Input, OnInit} from '@angular/core';
import {BrandService} from '../services/brand.service';
import {ActivatedRoute, Router} from '@angular/router';
import {ShopingService} from '../services/shoping.service';

@Component({
  selector: 'app-order-items',
  templateUrl: './order-items.component.html',
  styleUrls: ['./order-items.component.scss']
})
export class OrderItemsComponent implements OnInit {
    @Input() id: number;
    @Input() name: string;
    @Input() quantity: string;
    products = [];
    ido;
    order;
    url = 'http://localhost:8888/pfe_marketplace/web/uploads/product/';
  constructor(private brandService: BrandService, private router: ActivatedRoute, private route: Router,
   private shopingService: ShopingService) {
      this.ido = this.router.snapshot.params['ido'];
      this.order = this.shopingService.getOrder(+this.ido);
      for (const item of this.order.items) {
          this.products.push(this.brandService.getProduct(+item.product));
      }
  }

  ngOnInit() {
  }

}
