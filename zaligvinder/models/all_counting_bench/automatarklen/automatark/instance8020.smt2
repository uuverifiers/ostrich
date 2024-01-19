(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Porta\s+SSKC\s+\.cfgmPOPrtCUSTOMPalToolbarUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "Porta") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "SSKC") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ".cfgmPOPrtCUSTOMPalToolbarUser-Agent:\u{0a}"))))
; ^(\+27|27)?(\()?0?[87][23467](\))?( |-|\.|_)?(\d{3})( |-|\.|_)?(\d{4})
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "+27") (str.to_re "27"))) (re.opt (str.to_re "(")) (re.opt (str.to_re "0")) (re.union (str.to_re "8") (str.to_re "7")) (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "6") (str.to_re "7")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re ".") (str.to_re "_"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re ".") (str.to_re "_"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Host\x3A\dMicrosoft\w+\+Version\+
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "Microsoft") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "+Version+\u{0a}")))))
; ^((2[0-5][0-5]|1[\d][\d]|[\d][\d]|[\d])\.){3}(2[0-5][0-5]|1[\d][\d]|[\d][\d]|[\d])$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.++ (re.union (re.++ (str.to_re "2") (re.range "0" "5") (re.range "0" "5")) (re.++ (str.to_re "1") (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "0" "9") (re.range "0" "9")) (re.range "0" "9")) (str.to_re "."))) (re.union (re.++ (str.to_re "2") (re.range "0" "5") (re.range "0" "5")) (re.++ (str.to_re "1") (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "0" "9") (re.range "0" "9")) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
