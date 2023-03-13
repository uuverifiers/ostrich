(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Port.*Pro.*www\u{2e}proventactics\u{2e}comwv=update\.cgidrivesDays
(assert (not (str.in_re X (re.++ (str.to_re "Port") (re.* re.allchar) (str.to_re "Pro") (re.* re.allchar) (str.to_re "www.proventactics.comwv=update.cgidrivesDays\u{0a}")))))
; ^(^(100{1,1}$)|^(100{1,1}\.[0]+?$))|(^([0]*\d{0,2}$)|^([0]*\d{0,2}\.(([0][1-9]{1,1}[0]*)|([1-9]{1,1}[0]*)|([0]*)|([1-9]{1,2}[0]*)))$)$
(assert (str.in_re X (re.union (re.++ (re.union (re.++ (re.* (str.to_re "0")) ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (re.* (str.to_re "0")) ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re ".") (re.union (re.++ (str.to_re "0") ((_ re.loop 1 1) (re.range "1" "9")) (re.* (str.to_re "0"))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.* (str.to_re "0"))) (re.* (str.to_re "0")) (re.++ ((_ re.loop 1 2) (re.range "1" "9")) (re.* (str.to_re "0")))))) (str.to_re "\u{0a}")) (re.++ (str.to_re "10") ((_ re.loop 1 1) (str.to_re "0"))) (re.++ (str.to_re "10") ((_ re.loop 1 1) (str.to_re "0")) (str.to_re ".") (re.+ (str.to_re "0"))))))
; /filename=[^\n]*\u{2e}tif/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".tif/i\u{0a}"))))
(check-sat)
