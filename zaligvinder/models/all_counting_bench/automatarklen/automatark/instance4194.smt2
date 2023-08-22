(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^Referer\u{3a}\u{20}http\u{3a}\u{2f}\u{2f}[^\n]+\/\d{10,20}\u{0d}\u{0a}/Hm
(assert (not (str.in_re X (re.++ (str.to_re "/Referer: http://") (re.+ (re.comp (str.to_re "\u{0a}"))) (str.to_re "/") ((_ re.loop 10 20) (re.range "0" "9")) (str.to_re "\u{0d}\u{0a}/Hm\u{0a}")))))
; /update\/barcab\/.*?tn=.*id=.*version=/smi
(assert (str.in_re X (re.++ (str.to_re "/update/barcab/") (re.* re.allchar) (str.to_re "tn=") (re.* re.allchar) (str.to_re "id=") (re.* re.allchar) (str.to_re "version=/smi\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
