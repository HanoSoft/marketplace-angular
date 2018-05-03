import {AbstractControl} from '@angular/forms';

export const passwordMatcher = (control: AbstractControl): {[key: string]: boolean} => {
    const pwd = control.get('newPassword');
    const confirm = control.get('confirmPwd');
    if (pwd.value === confirm.value) {
        return null;
    } else {
        return { nomatch: true };
    }
};
