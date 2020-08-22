oc create -f install.yml
while true; do
  oc get crd | grep localvolumes.local.storage.openshift.io 2>/dev/null && break;
  echo "Waiting for CRD localvolumes.local.storage.openshift.io to be created"
  sleep 15
done
oc create -f cr.yml
while true; do
  oc get sc/{{ localstorage_storageclass }} 2>/dev/null && break;
  echo "Waiting for the storageclass to be created"
  sleep 5
done
{% if localstorage_default_storageclass %}
 oc patch storageclass {{ localstorage_storageclass }} -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
{% else %}
echo Run the following command to make localstorage the default storage class
echo oc patch storageclass {{ localstorage_storageclass }} -p \'{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}\'
{% endif %}
