import {AbstractControl} from '@angular/forms';

export const emailMatcher = (control: AbstractControl): {[key: string]: boolean} => {
    const email = control.get('newEmail');
    const confirm = control.get('confirmEmail');
    console.log('email is' + email.value + ' ' + confirm.value);
    if (email.value === confirm.value) {
        return null;
    } else {
        console.log('erreur de form email');
        return { nomatch: true };
    }
};
