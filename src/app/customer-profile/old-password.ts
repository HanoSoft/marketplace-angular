import {AbstractControl} from '@angular/forms';

export const oldPassword = (control: AbstractControl): {[key: string]: boolean} => {
    const pwd = control.get('password');
    if (pwd.value === localStorage.getItem('pwd')) {
        return null;
    } else {
        console.log('erreur de form pwd');
        return { invalidPwd: true };
    }
};
