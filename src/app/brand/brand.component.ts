import {Component, Input, OnInit} from '@angular/core';

@Component({
  selector: 'app-brand',
  templateUrl: './brand.component.html',
  styleUrls: ['./brand.component.scss']
})
export class BrandComponent implements OnInit {
    @Input() id: number;
    @Input() tagName: string;
    @Input() brandName: string;
    @Input() description: string;
    @Input() categories = [];
    @Input() image: string;
    @Input() logo: string;
    @Input() brandtag: string;
    url = 'http://localhost:8888/pfe_marketplace/web/uploads/brand/';
  ngOnInit() {}
}
