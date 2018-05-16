import {Component, Input, OnInit} from '@angular/core';

@Component({
  selector: 'app-order-items',
  templateUrl: './order-items.component.html',
  styleUrls: ['./order-items.component.scss']
})
export class OrderItemsComponent implements OnInit {
    @Input() id: number;
    @Input() name: string;
    @Input() quantity: string;
  constructor() { }

  ngOnInit() {
  }

}
