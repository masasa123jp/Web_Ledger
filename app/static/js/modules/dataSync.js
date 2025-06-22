// /static/js/dataSync.js
class DataSync {
  constructor() {
    this.apiBaseUrl = '/api/data_mgmt';
  }
  async fetch(module, params={}) {
    const response = await axios.get(`${this.apiBaseUrl}/${module}`, { params });
    return response.data;
  }
  async create(module, data) {
    const response = await axios.post(`${this.apiBaseUrl}/${module}`, data);
    return response.data;
  }
  async update(module, data) {
    const response = await axios.put(`${this.apiBaseUrl}/${module}`, data);
    return response.data;
  }
  async delete(module, id) {
    const response = await axios.delete(`${this.apiBaseUrl}/${module}/${id}`);
    return response.data;
  }
}
export default new DataSync();
