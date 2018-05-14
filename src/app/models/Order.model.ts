import {Item} from './Item.model';

export class Order {
    constructor(
        public amount: number,
        public items: Item [],
    ) {}
}
