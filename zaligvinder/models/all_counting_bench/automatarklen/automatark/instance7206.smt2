(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; zopabora\x2EinfocomhoroscopeTravelInsidefromUser-Agent\x3AFrom\x3Awww\x2EZSearchResults\x2EcomExplorer
(assert (not (str.in_re X (str.to_re "zopabora.infocomhoroscopeTravelInsidefromUser-Agent:From:www.ZSearchResults.com\u{13}Explorer\u{0a}"))))
; search\u{2e}imesh\u{2e}com\s+WatchDogupwww\.klikvipsearch\.com
(assert (not (str.in_re X (re.++ (str.to_re "search.imesh.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "WatchDogupwww.klikvipsearch.com\u{0a}")))))
; (0|(\+)?([1-9]{1}[0-9]{0,1}|[1]{1}[0-9]{0,2}|[2]{1}([0-4]{1}[0-9]{1}|[5]{1}[0-5]{1})))
(assert (str.in_re X (re.++ (re.union (str.to_re "0") (re.++ (re.opt (str.to_re "+")) (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.opt (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "1")) ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "2")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "4")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "5")) ((_ re.loop 1 1) (re.range "0" "5")))))))) (str.to_re "\u{0a}"))))
; ^([0-9]{12},)+[0-9]{12}$|^([0-9]{12})$
(assert (not (str.in_re X (re.union (re.++ (re.+ (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
