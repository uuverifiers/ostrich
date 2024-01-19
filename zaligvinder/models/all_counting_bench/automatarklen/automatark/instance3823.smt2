(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\.php\?mac\u{3d}([a-f0-9]{2}\u{3a}){5}[a-f0-9]{2}$/U
(assert (str.in_re X (re.++ (str.to_re "/.php?mac=") ((_ re.loop 5 5) (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ":"))) ((_ re.loop 2 2) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/U\u{0a}"))))
; \d{0,7}([\.|\,]\d{0,2})?
(assert (str.in_re X (re.++ ((_ re.loop 0 7) (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re ".") (str.to_re "|") (str.to_re ",")) ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^(1[0-2]|0?[1-9]):([0-5]?[0-9])( AM| PM)$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9"))) (str.to_re ":\u{0a}") (re.opt (re.range "0" "5")) (re.range "0" "9") (str.to_re " ") (re.union (str.to_re "AM") (str.to_re "PM")))))
; /filename=[^\n]*\u{2e}xps/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xps/i\u{0a}")))))
; User-Agent\x3AUser-Agent\u{3a}
(assert (not (str.in_re X (str.to_re "User-Agent:User-Agent:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
