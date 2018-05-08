import { Component, OnInit } from '@angular/core';
import {ShopingService} from '../services/shoping.service';

@Component({
  selector: 'app-confirmation',
  templateUrl: './confirmation.component.html',
  styleUrls: ['./confirmation.component.scss']
})
export class ConfirmationComponent implements OnInit {
  pay = true;
  constructor(private shopingService: ShopingService) { }

  ngOnInit() {
    this.shopingService.saveItems();
  }

}
