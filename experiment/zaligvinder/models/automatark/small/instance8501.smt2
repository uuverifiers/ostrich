(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z0-9\.\s]{3,}$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))))
; com\x2Findex\.php\?tpid=onspyblpatUser-Agent\x3ASurveillance
(assert (str.in_re X (str.to_re "com/index.php?tpid=onspyblpatUser-Agent:Surveillance\u{13}\u{0a}")))
; IP-[^\n\r]*URL\d\u{7c}roogoo\u{7c}\.cfgmPOPrtCUSTOMPalToolbar
(assert (str.in_re X (re.++ (str.to_re "IP-") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "URL") (re.range "0" "9") (str.to_re "|roogoo|.cfgmPOPrtCUSTOMPalToolbar\u{0a}"))))
; ^\d+(\.\d+)?$
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(check-sat)
