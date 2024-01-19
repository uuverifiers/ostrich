(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; $sPatternTablet = '/(Tablet|iPad|iPod)/';
(assert (not (str.in_re X (re.++ (str.to_re "sPatternTablet = '/") (re.union (str.to_re "Tablet") (str.to_re "iPad") (str.to_re "iPod")) (str.to_re "/';\u{0a}")))))
; /filename=[^\n]*\u{2e}max/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".max/i\u{0a}")))))
; ^(([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+([;.](([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+)*$
(assert (str.in_re X (re.++ (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 1 25) ((_ re.loop 2 5) (re.union (re.range "a" "z") (re.range "A" "Z")))))) (re.* (re.++ (re.union (str.to_re ";") (str.to_re ".")) (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 1 25) ((_ re.loop 2 5) (re.union (re.range "a" "z") (re.range "A" "Z")))))))) (str.to_re "\u{0a}"))))
; is\s+lnzzlnbk\u{2f}pkrm\.fin\s+Host\x3A\x2Ftoolbar\x2Fsupremetb
(assert (str.in_re X (re.++ (str.to_re "is") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "lnzzlnbk/pkrm.fin") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:/toolbar/supremetb\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
