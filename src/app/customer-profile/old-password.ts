import {AbstractControl} from '@angular/forms';
import * as sha1 from 'js-sha1';
export const oldPassword = (control: AbstractControl): {[key: string]: boolean} => {
    const pwd = control.get('password');
    if (sha1(pwd.value) === localStorage.getItem('pwd')) {
        return null;
    } else {
        console.log('erreur de form pwd');
        return { invalidPwd: true };
    }
};
