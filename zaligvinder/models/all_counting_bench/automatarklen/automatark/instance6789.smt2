(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^([a-zA-Z0-9])(([\-.]|[_]+)?([a-zA-Z0-9]+))*(@){1}[a-z0-9]+[.]{1}(([a-z]{2,3})|([a-z]{2,3}[.]{1}[a-z]{2,3}))$/
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (re.* (re.++ (re.opt (re.union (re.+ (str.to_re "_")) (str.to_re "-") (str.to_re "."))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))) ((_ re.loop 1 1) (str.to_re "@")) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) ((_ re.loop 1 1) (str.to_re ".")) (re.union ((_ re.loop 2 3) (re.range "a" "z")) (re.++ ((_ re.loop 2 3) (re.range "a" "z")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 2 3) (re.range "a" "z")))) (str.to_re "/\u{0a}"))))
; DesktopBladeclient=wwwHello\x2Exmlns\x3A
(assert (str.in_re X (str.to_re "DesktopBladeclient=wwwHello.xmlns:\u{0a}")))
; MyBrowserSbAtsHost\x3A
(assert (not (str.in_re X (str.to_re "MyBrowserSbAtsHost:\u{0a}"))))
; ^((00|\+)49)?(0?[2-9][0-9]{1,})$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "00") (str.to_re "+")) (str.to_re "49"))) (str.to_re "\u{0a}") (re.opt (str.to_re "0")) (re.range "2" "9") (re.+ (re.range "0" "9")))))
; ^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)+$
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re "_") (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (str.to_re "_") (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (re.+ (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
