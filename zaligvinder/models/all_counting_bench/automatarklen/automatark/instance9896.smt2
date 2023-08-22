(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A\s+www\x2Emyarmory\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.myarmory.com\u{0a}"))))
; /filename=[^\n]*\u{2e}hhk/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".hhk/i\u{0a}"))))
; Address\x3A\s+SbAtsHTTP_RAT_Subject\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Address:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "SbAtsHTTP_RAT_Subject:\u{0a}")))))
; ^(\$|R\$|\-\$|\-R\$|\$\-|R\$\-|-)?([0-9]{1}[0-9]{0,2}(\.[0-9]{3})*(\,[0-9]{0,2})?|[1-9]{1}[0-9]{0,}(\,[0-9]{0,2})?|0(\,[0-9]{0,2})?|(\,[0-9]{1,2})?)$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "$") (str.to_re "R$") (str.to_re "-$") (str.to_re "-R$") (str.to_re "$-") (str.to_re "R$-") (str.to_re "-"))) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ",") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ",") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (str.to_re "0") (re.opt (re.++ (str.to_re ",") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.opt (re.++ (str.to_re ",") ((_ re.loop 1 2) (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
