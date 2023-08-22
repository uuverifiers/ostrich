(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /gate\u{2e}php\u{3f}reg=[a-z]{10}/U
(assert (not (str.in_re X (re.++ (str.to_re "/gate.php?reg=") ((_ re.loop 10 10) (re.range "a" "z")) (str.to_re "/U\u{0a}")))))
; /filename=[^\n]*\u{2e}rtx/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rtx/i\u{0a}"))))
; ^-?((([1]?[0-7][0-9]|[1-9]?[0-9])\.{1}\d{1,6}$)|[1]?[1-8][0]\.{1}0{1,6}$)
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.union (re.++ (re.opt (str.to_re "1")) (re.range "0" "7") (re.range "0" "9")) (re.++ (re.opt (re.range "1" "9")) (re.range "0" "9"))) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ (re.opt (str.to_re "1")) (re.range "1" "8") (str.to_re "0") ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 6) (str.to_re "0")))) (str.to_re "\u{0a}")))))
; that.*CodeguruBrowser.*CasinoBladeisInsideupdate\.cgiHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "that") (re.* re.allchar) (str.to_re "CodeguruBrowser") (re.* re.allchar) (str.to_re "CasinoBladeisInsideupdate.cgiHost:\u{0a}")))))
; IDENTIFY666User-Agent\x3A\x5BStaticSend=Host\x3Awww\.iggsey\.com
(assert (not (str.in_re X (str.to_re "IDENTIFY666User-Agent:[StaticSend=Host:www.iggsey.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
