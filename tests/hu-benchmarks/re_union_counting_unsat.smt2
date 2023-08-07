;test regex ^100$|^[0-9]{1,2}$|^[0-9]{1,2}\,[0-9]{1,3}$
(declare-const X String)
(assert (str.in_re X (re.union re.allchar ((_ re.loop 0 3) re.allchar))))

(assert (< 10 (str.len X)))
(check-sat)
(get-model)