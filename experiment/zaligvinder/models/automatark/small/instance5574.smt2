(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; 714|760|949|619|909|951|818|310|323|213|323|562|626-\d{3}-\d{4}
(assert (str.in_re X (re.union (str.to_re "714") (str.to_re "760") (str.to_re "949") (str.to_re "619") (str.to_re "909") (str.to_re "951") (str.to_re "818") (str.to_re "310") (str.to_re "323") (str.to_re "213") (str.to_re "323") (str.to_re "562") (re.++ (str.to_re "626-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /^\/\w{1,2}\/\w{1,3}\.class$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 1 2) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/") ((_ re.loop 1 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".class/U\u{0a}"))))
; /filename=[^\n]*\u{2e}jpf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jpf/i\u{0a}")))))
; (DK-?)?([0-9]{2}\ ?){3}[0-9]{2}
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "DK") (re.opt (str.to_re "-")))) ((_ re.loop 3 3) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
