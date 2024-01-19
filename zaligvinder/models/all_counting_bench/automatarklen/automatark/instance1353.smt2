(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9]{2})(01|02|03|04|05|06|07|08|09|10|11|12|51|52|53|54|55|56|57|58|59|60|61|62)(([0]{1}[1-9]{1})|([1-2]{1}[0-9]{1})|([3]{1}[0-1]{1}))/([0-9]{3,4})$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re "01") (str.to_re "02") (str.to_re "03") (str.to_re "04") (str.to_re "05") (str.to_re "06") (str.to_re "07") (str.to_re "08") (str.to_re "09") (str.to_re "10") (str.to_re "11") (str.to_re "12") (str.to_re "51") (str.to_re "52") (str.to_re "53") (str.to_re "54") (str.to_re "55") (str.to_re "56") (str.to_re "57") (str.to_re "58") (str.to_re "59") (str.to_re "60") (str.to_re "61") (str.to_re "62")) (re.union (re.++ ((_ re.loop 1 1) (str.to_re "0")) ((_ re.loop 1 1) (re.range "1" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "2")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "3")) ((_ re.loop 1 1) (re.range "0" "1")))) (str.to_re "/") ((_ re.loop 3 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; (?s)/\*.*\*/
(assert (str.in_re X (re.++ (str.to_re "/*") (re.* re.allchar) (str.to_re "*/\u{0a}"))))
; ^([0-2]\d|3[0-1]|[1-9])\/(0\d|1[0-2]|[1-9])\/(\d{4})$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1")) (re.range "1" "9")) (str.to_re "/") (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2")) (re.range "1" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
